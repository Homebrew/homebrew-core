class Arangodb < Formula
  desc "Multi-Model NoSQL Database"
  homepage "https://www.arangodb.com/"
  url "https://download.arangodb.com/Source/ArangoDB-3.9.2.tar.bz2"
  sha256 "35ac1678b91c0cc448454ef3a76637682d095328570674a5765ae5d060c5721b"
  license "Apache-2.0"
  head "https://github.com/arangodb/arangodb.git", branch: "devel"

  livecheck do
    url "https://www.arangodb.com/download-major/source/"
    regex(/href=.*?ArangoDB[._-]v?(\d+(?:\.\d+)+)(-\d+)?\.t/i)
  end

  bottle do
    sha256 monterey:     "6ce88863c3d64b6e0f80157b81ccada705ba6a364ee8ff827e46f63df16b3b10"
    sha256 big_sur:      "e38065e33bd2ee3eee533bcde177f1ce0c3dfd7c8857f678fe73d4e2e8fcec75"
    sha256 catalina:     "5420623e77cc3c4dd8c272a791ce8d102d46fdceeea983104f2443a6b2cb95c8"
    sha256 x86_64_linux: "8c311faac036bab8fc2acee10adf136275ccbf5c976795fadae2b08adaefffaf"
  end

  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "go@1.17" => :build
  depends_on "python@3.10" => :build
  depends_on macos: :mojave
  depends_on "openssl@1.1"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # the ArangoStarter is in a separate github repository;
  # it is used to easily start single server and clusters
  # with a unified CLI
  resource "starter" do
    url "https://github.com/arangodb-helper/arangodb.git",
        tag:      "0.15.4",
        revision: "ed743d2293efd763309f3ba0a1ba6fb68ac4a41a"
  end

  # Fix compilation with Apple clang 13.1.6, remove in next release
  patch do
    url "https://github.com/arangodb/arangodb/commit/fd43fbc27.patch?full_index=1"
    sha256 "0298670362e04ec0870f6b7032dff83bfcdf9a04f2fa4763ce5186d4e10a3abb"
  end

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version if OS.mac?

    resource("starter").stage do
      ENV["GO111MODULE"] = "on"
      ENV["DOCKERCLI"] = ""
      ldflags = %W[
        -s -w
        -X main.projectVersion=#{resource("starter").version}
        -X main.projectBuild=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(ldflags: ldflags), "github.com/arangodb-helper/arangodb"
    end

    openssl = Formula["openssl@1.1"]
    args = std_cmake_args + %W[
      -DHOMEBREW=ON
      -DCMAKE_BUILD_TYPE=RelWithDebInfo
      -DUSE_MAINTAINER_MODE=Off
      -DUSE_JEMALLOC=Off
      -DCMAKE_LIBRARY_PATH=#{openssl.opt_lib}
      -DOPENSSL_ROOT_DIR=#{openssl.opt_lib}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -DUSE_CATCH_TESTS=Off
      -DUSE_GOOGLE_TESTS=Off
      -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
    ]
    args << "-DTARGET_ARCHITECTURE=nehalem" if build.bottle? && Hardware::CPU.intel?

    ENV["V8_CXXFLAGS"] = "-O3 -g -fno-delete-null-pointer-checks" if ENV.compiler == "gcc-6"

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
