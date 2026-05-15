class Drogon < Formula
  desc "Modern C++ web application framework"
  homepage "https://drogon.org"
  # pull from git tag to get submodules
  url "https://github.com/drogonframework/drogon.git",
      tag:      "v1.9.13",
      revision: "4c5430757ea5451a7c38fbbef4b4bef7dbb47f2f"
  license "MIT"
  head "https://github.com/drogonframework/drogon.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "bd4e451e290fe59e8a97d423868017e5973dec2a282bddeaa37b9ed9aac479a4"
    sha256                               arm64_sequoia: "359653713e2a256dab4f2997cd0b35d528b8e00e605bb27b866aef387f76e5f8"
    sha256                               arm64_sonoma:  "64b5c9c0120a69a16c6cc23ff1fe7a0aaf0f24fa46405cad14b5469e2fe58b0d"
    sha256                               sonoma:        "1e4f10a5417224e39f16f2c74d8c1cae7e13f4ca824f9545905bc10b7edec65e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3fc5b99f99e7254e3fd7ed42288339e4278277361dbe7d723d829394bda069c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f6fc1a8a1e4a57deb723112fac807e92b956be749d51872198a8dbcedc5a2a9"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "openssl@3"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux"
    depends_on "zlib-ng-compat"
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
