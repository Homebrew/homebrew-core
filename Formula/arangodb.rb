class Arangodb < Formula
  desc "Multi-Model NoSQL Database"
  homepage "https://www.arangodb.com/"
  url "https://download.arangodb.com/Source/ArangoDB-3.9.3.tar.bz2"
  sha256 "7650781ba21723b6a361d4cf8a03acbf45a1091bc77704236597a934768b059d"
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

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "python@3.10" => :build
  depends_on macos: :mojave
  depends_on "openssl@1.1"

  # https://www.arangodb.com/docs/stable/installation-compiling-debian.html
  fails_with :gcc do
    version "8"
    cause "requires at least g++ 9.2 as compiler since v3.7"
  end

  # the ArangoStarter is in a separate github repository;
  # it is used to easily start single server and clusters
  # with a unified CLI
  resource "starter" do
    url "https://github.com/arangodb-helper/arangodb.git",
        tag:      "0.15.5",
        revision: "7832707bbf7d1ab76bb7f691828cfda2a7dc76cb"
  end

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version if OS.mac?

    resource("starter").stage do
      ldflags = %W[
        -s -w
        -X main.projectVersion=#{resource("starter").version}
        -X main.projectBuild=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(ldflags: ldflags), "github.com/arangodb-helper/arangodb"
    end

    args = std_cmake_args + %W[
      -DHOMEBREW=ON
      -DCMAKE_BUILD_TYPE=RelWithDebInfo
      -DUSE_MAINTAINER_MODE=Off
      -DUSE_JEMALLOC=Off
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
      -DUSE_CATCH_TESTS=Off
      -DUSE_GOOGLE_TESTS=Off
      -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
    ]
    args << "-DTARGET_ARCHITECTURE=nehalem" if build.bottle? && Hardware::CPU.intel?

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
