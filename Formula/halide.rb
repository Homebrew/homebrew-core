class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/v11.0.1.tar.gz"
  sha256 "4db6c4697fd5b84298cb91c13d86d9e95b0f9a65227af39374e2da98b503c8f2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f2c09c883b06369408e91662ac43392605ea44211df05cfbe04536e29963dff5"
    sha256 cellar: :any, big_sur:       "cf8ac2f34055e99adc3a7fbebf6a842212f44c4ca0a7af22c23141b2f5ddae05"
    sha256 cellar: :any, catalina:      "04dba10ef3d57f9261a67a6ca76ae343546f6a7030f5656acb366cc7f156867d"
    sha256 cellar: :any, mojave:        "f79f5fa9c1dd02bba46368158c478b32d37ef708903068c81781cd7115510177"
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libomp"
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
    cp share/"tutorial/lesson_01_basics.cpp", testpath
    system ENV.cxx, "-std=c++11", "lesson_01_basics.cpp", "-L#{lib}", "-lHalide", "-o", "test"
    assert_match "Success!", shell_output("./test")
  end
end
