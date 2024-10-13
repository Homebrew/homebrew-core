class Drogon < Formula
  desc "Modern C++ web application framework"
  homepage "https://drogon.org"
  # pull from git tag to get submodules
  url "https://github.com/drogonframework/drogon.git",
      tag:      "v1.9.7",
      revision: "73406d122543f548c9d07076e16880b777bfc109"
  license "MIT"
  revision 1
  head "https://github.com/drogonframework/drogon.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6e5c2c9f0a9898ed4a9ac341f02248be3109efbf8501f61e005c6cb8920786ce"
    sha256 cellar: :any,                 arm64_sonoma:  "fd69ea0690b8381d7ca88befe9e67b15f95f75d1047dc9ce26e94b0a12ca0c04"
    sha256 cellar: :any,                 arm64_ventura: "bcc3bb89f6d57916b909429106b4a7c88d608bc62646619972ad9e47e2ce3eef"
    sha256 cellar: :any,                 sonoma:        "c6c347855028f544468d042582801eeff704544901f9c57b40bf1ef9d561d163"
    sha256 cellar: :any,                 ventura:       "ff1e43236ae8d6fe6d400ce3196434aeac2748f96f0c40b7d69c70175634612e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "038d5dae86f567bebcc21b0b57bb5072682f19ecac924f27652208c46411d55e"
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
    args = []
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
