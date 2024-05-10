class Drogon < Formula
  desc "Modern C++ web application framework"
  homepage "https://drogon.org"
  # pull from git tag to get submodules
  url "https://github.com/drogonframework/drogon.git",
      tag:      "v1.9.4",
      revision: "b5cd748a12cd02a2511fd14a89567584430ed620"
  license "MIT"
  head "https://github.com/drogonframework/drogon.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dc663439aa8434e28420f03dc548b82cc4faeecd0d8bf0127cc7afdf486f6408"
    sha256 cellar: :any,                 arm64_ventura:  "f3d5855334032105de46d67c3f110a3912f36bf0c953c2db6c4e56f83f722f48"
    sha256 cellar: :any,                 arm64_monterey: "84c9b136f02bc6ab4c3dcddf9182a71ec3a3de138994fd3f932556f8e9e4bb8e"
    sha256 cellar: :any,                 sonoma:         "6aa5092894bf5358b4e9160310a8c00b711d7a990a705288be7429879f2d06a2"
    sha256 cellar: :any,                 ventura:        "84e9f393a0f0980da96953777dab340edb56474661751a94c56a1b477c96ddd7"
    sha256 cellar: :any,                 monterey:       "cab170bbdeaeb1b497c02904c4de1e9aa5a6bf00625f1980e69c7f5c734c8335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2bff8e290a0dd896698b780ac491c20853fbad2d008fd1f377ccfc549cb0939"
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
