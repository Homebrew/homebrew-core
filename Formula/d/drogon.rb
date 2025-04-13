class Drogon < Formula
  desc "Modern C++ web application framework"
  homepage "https://drogon.org"
  # pull from git tag to get submodules
  url "https://github.com/drogonframework/drogon.git",
      tag:      "v1.9.10",
      revision: "cbf63f8fc4d849bbb82eeb1c83fcf8ff953f19f3"
  license "MIT"
  head "https://github.com/drogonframework/drogon.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "eaa532684adb01456ea16257408c2fc1e630ec7f369eaec77a9a18290c5c3b41"
    sha256                               arm64_sonoma:  "8c5850884ec0ae09d4b17f37f3b3b8ff52c9b32f1160c95332a6208ab5085d45"
    sha256                               arm64_ventura: "452c23f0d15e9fae038387c4b7e9d151c80b9ce0f182a823b426e761bbb1dce6"
    sha256                               sonoma:        "1f7d3528eafbd4fd89b546f930293184c08a1b96d3cafc849ed7b0d93d497c27"
    sha256                               ventura:       "34690a0d3adc7ef0d65366be9f7c73baa7b3d2ca77368c1a71ded22f6584cdd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbbff4e21d26ba23715324ed47a6d66be5bf6a935160ef30684f7ada91839ebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4d380c27cc5a5230b12e1889fca7fd3e6fad564e13a56021a8c3d26cc88d49e"
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
