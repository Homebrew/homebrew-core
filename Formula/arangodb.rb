class Arangodb < Formula
  desc "Multi-Model NoSQL Database"
  homepage "https://www.arangodb.com/"
  url "https://download.arangodb.com/Source/ArangoDB-3.8.3.tar.bz2"
  sha256 "d7c6e705d59412eb5a87457c7f88a96a655af87845a201d5bf7e62fadcd50f78"
  license "Apache-2.0"
  head "https://github.com/arangodb/arangodb.git", branch: "devel"

  livecheck do
    url "https://www.arangodb.com/download-major/source/"
    regex(/href=.*?ArangoDB[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 big_sur:  "edcde31b2fd366c7d758ffc0b77aa884f31730e936917515a7a4cd6cc9a51feb"
    sha256 catalina: "a3d03ffa2a2164a2d88aff4ed462f4b08c5bbd9bc13d674e91fe1ad1cc436898"
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
        tag:      "0.15.3",
        revision: "814f8be9e5cc613a63ac1dc161b879ccb7ec23e0"
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
      system "go", "build", *std_go_args(ldflags: ldflags), "github.com/arangodb-helper/arangodb"
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
