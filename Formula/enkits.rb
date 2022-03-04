class Enkits < Formula
  desc "C and C++ Task Scheduler for creating parallel programs"
  homepage "https://github.com/dougbinks/enkiTS"
  url "https://github.com/dougbinks/enkiTS/archive/refs/tags/v1.11.tar.gz"
  sha256 "b57a782a6a68146169d29d180d3553bfecb9f1a0e87a5159082331920e7d297e"
  license "Zlib"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a16d0e8f1b5ad4069eba83f3df23924dd498916b41a6f0f6a81c3dce22d42b7a"
    sha256 cellar: :any, big_sur:       "52f4e994abed0b9c4d9a7ccc225b98d1cf4f4fe462aea61f2fd1b116f518c904"
    sha256 cellar: :any, catalina:      "4b263189bb7bf94c1a1f9907fd4c988658c217db6a1897ad4d022354da32be56"
    sha256 cellar: :any, mojave:        "be477295d82fdc58a9745c310c4a286fbaf77f74211a40ed9042cbed1f58810a"
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
