class Enkits < Formula
  desc "C and C++ Task Scheduler for creating parallel programs"
  homepage "https://github.com/dougbinks/enkiTS"
  url "https://github.com/dougbinks/enkiTS/archive/refs/tags/v1.9.tar.gz"
  sha256 "4678526aa3f1a0e93d23c5c381ea56509441f4574ddbdf1f9aa01c6b3e659afd"
  license "Zlib"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e858429523c2b0db644ff13e896526965eb01ae88d93c1fec8ec0ba56d087a06"
    sha256 cellar: :any, big_sur:       "ae4abf4aae65a0e7895c1a8ee14b64d619a7abd16456b4715811d169f8155e65"
    sha256 cellar: :any, catalina:      "60125a7fe72094782ba4f69c0dc756604e388c8f0c7a386c71469f974b20c7f8"
    sha256 cellar: :any, mojave:        "92d1e3e99ffc1146c4e18c921ba5dbf0085de90652d4caa12114968c40080dc6"
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args + %w[
      -DENKITS_BUILD_EXAMPLES=OFF
      -DENKITS_INSTALL=ON
      -DENKITS_BUILD_SHARED=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    lib.install_symlink "#{lib}/enkiTS/#{shared_library("libenkiTS")}"
    pkgshare.install "example"
  end

  test do
    system ENV.cxx, pkgshare/"example/PinnedTask.cpp",
      "-std=c++11", "-I#{include}/enkiTS", "-L#{lib}", "-lenkiTS", "-o", "example"
    output = shell_output("./example")
    assert_match("This will run on the main thread", output)
    assert_match(/This could run on any thread, currently thread \d/, output)
  end
end
