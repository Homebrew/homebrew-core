class Drogon < Formula
  desc "Modern C++ web application framework"
  homepage "https://drogon.org"
  # pull from git tag to get submodules
  url "https://github.com/drogonframework/drogon.git",
      tag:      "v1.9.6",
      revision: "e78690747858f49d7ea08002083420ff046d8785"
  license "MIT"
  head "https://github.com/drogonframework/drogon.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "96150e67616b00dae86966bf72a680bf45833279adc87eacc57d6212dcfb524f"
    sha256 cellar: :any,                 arm64_ventura:  "a22b44abb7f95aafee6b46123020a221c44e96005e993132dd3dc45552c3c626"
    sha256 cellar: :any,                 arm64_monterey: "b813b3be2dee020a42a6278639dc4396d1903394401085ad673eed4519c17df9"
    sha256 cellar: :any,                 sonoma:         "e5b76a1ad30fb0f754202f7a9c873c6bbaa8744b8066e619fe9eef7da8f6f05c"
    sha256 cellar: :any,                 ventura:        "44a3af6698e27b1713d60ddb955899b8d5bf2422f0f30b73379dc6cf6981c87e"
    sha256 cellar: :any,                 monterey:       "96393c7e4f4c81fc9f70343e3e3066f30ca8720e5d7a1e0064e386ff1132014a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47018e883a894c296d52cb43c4ae4fb0b85dc819044e427a66e1ecd87444b04f"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "openssl@3"
  depends_on "ossp-uuid"

  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args
    if OS.linux?
      cmake_args << "-DUUID_LIBRARIES=uuid"
      cmake_args << "-DUUID_INCLUDE_DIRS=#{Formula["ossp-uuid"].opt_include}/ossp"
    end

    system "cmake", "-B", "build", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"dg_ctl", "create", "project", "hello"
    cd "hello" do
      port = free_port
      inreplace "main.cc", "5555", port.to_s

      cmake_args = []
      if OS.linux?
        cmake_args << "-DUUID_LIBRARIES=uuid"
        cmake_args << "-DUUID_INCLUDE_DIRS=#{Formula["ossp-uuid"].opt_include}/ossp"
      end

      system "cmake", "-B", "build", *cmake_args
      system "cmake", "--build", "build"

      begin
        pid = fork { exec "build/hello" }
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
