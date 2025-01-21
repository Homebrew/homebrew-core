class Drogon < Formula
  desc "Modern C++ web application framework"
  homepage "https://drogon.org"
  # pull from git tag to get submodules
  url "https://github.com/drogonframework/drogon.git",
      tag:      "v1.9.9",
      revision: "38dd5fea31a7a2727c0a6f6b6b04252374796cab"
  license "MIT"
  head "https://github.com/drogonframework/drogon.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "8dc2155bd7e8cc3c0051f94916eecf745776d2df8f1f47496e18faf21e36ab27"
    sha256                               arm64_sonoma:  "c93d9767414b174d4c1e9d8e04b52c3c39458a26ffdaee359fba557a5e3a66d0"
    sha256                               arm64_ventura: "15513fef0b3bbed6f98b4c180025e4a3c1482f74a3db073d6502b6ddadc744cc"
    sha256                               sonoma:        "389c469f48eb5e301057b59bfd8d89d17c8ed11499853ea9154aba60e9def0a8"
    sha256                               ventura:       "4b1a76323552af03a531fae8915a22535fb842a9eaa9b51076017665bd569f3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c566cde051d497bef9503d7a795c1331f5fecb58d347265dc04086c85128f89c"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "openssl@3"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    args << "-DUUID_DIR=#{Formula["util-linux"].opt_prefix}" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"dg_ctl", "create", "project", "hello"
    cd "hello" do
      port = free_port
      inreplace "main.cc", "5555", port.to_s

      system "cmake", "-S", ".", "-B", "build"
      system "cmake", "--build", "build"

      begin
        pid = spawn("build/hello")
        sleep 1
        result = shell_output("curl -s 127.0.0.1:#{port}")
        assert_match "<hr><center>drogon", result
      ensure
        Process.kill("SIGINT", pid)
        Process.wait(pid)
      end
    end
  end
end
