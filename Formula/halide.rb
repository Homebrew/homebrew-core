class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/v13.0.0.tar.gz"
  sha256 "5ab7d5d9bc04ab0902a88751e535ff231ab9da1911e46f272a52cf41131609f3"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "4d58708081b68b2054c323df7e46849360fc353bb26bb94f0ca1bc0c42096869"
    sha256 cellar: :any, arm64_big_sur:  "ed6402f7e024cb534d50751c3eb5aa364bdb396e7c6cd3ad0092de0fdb6aa505"
    sha256 cellar: :any, monterey:       "0d781b9447530746cd6d262cec7005df80918ebc1ff5b48cca544d33b02b8536"
    sha256 cellar: :any, big_sur:        "dd1c5a0f4d68e58a0c1e3e1d474c9e0c257122d84bb70044d15fc8a93a774bde"
    sha256 cellar: :any, catalina:       "25b4e27297e0e1431564fd032f5b6c674481c7b07a9289f9d2297bfae5e77cde"
    sha256 cellar: :any, mojave:         "1cbb1616fe39338760337bbd84b94ffea6e71db136c3c9013934fad191c1df3e"
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "llvm"
  depends_on "python@3.9"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DHalide_SHARED_LLVM=ON"
      system "make"
      system "make", "install"
    end
  end

  test do
    cp share/"doc/Halide/tutorial/lesson_01_basics.cpp", testpath
    system ENV.cxx, "-std=c++17", "lesson_01_basics.cpp", "-L#{lib}", "-lHalide", "-o", "test"
    assert_match "Success!", shell_output("./test")
  end
end
