class Drogon < Formula
  desc "Modern C++ web application framework"
  homepage "https://drogon.org"
  # pull from git tag to get submodules
  url "https://github.com/drogonframework/drogon.git",
      tag:      "v1.9.5",
      revision: "8bdb9b2fa6a773a0aebae3a306b9448d6cf0cb34"
  license "MIT"
  head "https://github.com/drogonframework/drogon.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cf301ef0d3d2ba63a173a463df9164a77f7df1ed882ac8804378a67022a66d1d"
    sha256 cellar: :any,                 arm64_ventura:  "ed0b8233ece7d56f8c5cceeee26de0a57520a61f18bb209a8a9d9d4645b8e2e7"
    sha256 cellar: :any,                 arm64_monterey: "74d8421166c1ff785b0bff177518659b0ee153dac0c84666c1a60f525c9ce14e"
    sha256 cellar: :any,                 sonoma:         "a33cd8c07e3631fe82861c700f56a3af5528b624f8fe4f4b8d056499f5c45254"
    sha256 cellar: :any,                 ventura:        "f40f798325694f143923cc347d6125b4fce3f0b4fb3dc704493c4a4d38eba6a4"
    sha256 cellar: :any,                 monterey:       "e4d639bb18f14c87b95b2bd2cbb93213f46db74a929e1d8b5bd9189904c33458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47c08897936fede441384e7ad9986b2014d582c73f9b2d746f8ff7a480891fda"
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
