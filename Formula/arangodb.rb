class Arangodb < Formula
  desc "Multi-Model NoSQL Database"
  homepage "https://www.arangodb.com/"
  url "https://download.arangodb.com/Source/ArangoDB-3.8.1.tar.gz"
  sha256 "31a17e09cd7fdec94430b8a97864009f24a142e35cdf185068fe148ae781c3a9"
  license "Apache-2.0"
  head "https://github.com/arangodb/arangodb.git", branch: "devel"

  bottle do
    sha256 big_sur:  "f895aba7329d3bf1f7dc40c6eac687320d722015fd237a0d61c2f320c5f27bf1"
    sha256 catalina: "76603e9b4734489f997141b5c378f13cb28a95bd6cd7059ea49b014d0845f994"
    sha256 mojave:   "3b5326020d7813edbf0fd42c3ed6c5f8a817603f0854778bb4a3cbb0b78e54eb"
  end

  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "go@1.13" => :build
  depends_on "python@3.9" => :build
  depends_on macos: :mojave
  depends_on "openssl@1.1"

  # the ArangoStarter is in a separate github repository;
  # it is used to easily start single server and clusters
  # with a unified CLI
  resource "starter" do
    url "https://github.com/arangodb-helper/arangodb.git",
        tag:      "0.15.1",
        revision: "3c27ad4cfb89e96db551445212f78706b7263851"
  end

  # Fix compilation with Xcode 13 on 10.14, remove in next release
  patch do
    url "https://github.com/arangodb/arangodb/commit/d3fde7986.patch?full_index=1"
    sha256 "9699643d4ea2f1b679631b92672215e258c3e7a958638f9fdd8d6de6910dc146"
  end

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version if OS.mac?

    resource("starter").stage do
      ENV["GO111MODULE"] = "on"
      ENV["DOCKERCLI"] = ""
      system "make", "deps"
      ldflags = %W[
        -s -w
        -X main.projectVersion=#{resource("starter").version}
        -X main.projectBuild=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args, "-ldflags", ldflags.join(" "), "github.com/arangodb-helper/arangodb"
    end

    mkdir "build" do
      openssl = Formula["openssl@1.1"]
      args = std_cmake_args + %W[
        -DHOMEBREW=ON
        -DCMAKE_BUILD_TYPE=RelWithDebInfo
        -DUSE_MAINTAINER_MODE=Off
        -DUSE_JEMALLOC=Off
        -DCMAKE_SKIP_RPATH=On
        -DOPENSSL_USE_STATIC_LIBS=On
        -DCMAKE_LIBRARY_PATH=#{openssl.opt_lib}
        -DOPENSSL_ROOT_DIR=#{openssl.opt_lib}
        -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
        -DTARGET_ARCHITECTURE=nehalem
        -DUSE_CATCH_TESTS=Off
        -DUSE_GOOGLE_TESTS=Off
        -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      ]

      ENV["V8_CXXFLAGS"] = "-O3 -g -fno-delete-null-pointer-checks" if ENV.compiler == "gcc-6"

      system "cmake", "..", *args
      system "make", "install"
    end
  end

  def post_install
    (var/"lib/arangodb3").mkpath
    (var/"log/arangodb3").mkpath
  end

  def caveats
    <<~EOS
      An empty password has been set. Please change it by executing
        #{opt_sbin}/arango-secure-installation
    EOS
  end

  service do
    run opt_sbin/"arangod"
    keep_alive true
  end

  test do
    require "pty"

    testcase = "require('@arangodb').print('it works!')"
    output = shell_output("#{bin}/arangosh --server.password \"\" --javascript.execute-string \"#{testcase}\"")
    assert_equal "it works!", output.chomp

    ohai "#{bin}/arangodb --starter.instance-up-timeout 1m --starter.mode single"
    PTY.spawn("#{bin}/arangodb", "--starter.instance-up-timeout", "1m",
              "--starter.mode", "single", "--starter.disable-ipv6",
              "--server.arangod", "#{sbin}/arangod",
              "--server.js-dir", "#{share}/arangodb3/js") do |r, _, pid|
      loop do
        available = r.wait_readable(60)
        refute_equal available, nil

        line = r.readline.strip
        ohai line

        break if line.include?("Your single server can now be accessed")
      end
    ensure
      Process.kill "SIGINT", pid
      ohai "shutting down #{pid}"
    end
  end
end
