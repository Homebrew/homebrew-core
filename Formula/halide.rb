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
    sha256 cellar: :any, arm64_big_sur: "ad19d68856aa1cc71143444247390ae4a6dd7e9f3ff62d466faca649f440d476"
    sha256 cellar: :any, big_sur:       "df941a4b7b9e384b396e2a023e44565c0fdcb725ef14fdaf27138f76f9d1c5ee"
    sha256 cellar: :any, catalina:      "300fb9d5ba8b9d5df83bf23edc62bd10f9614ccaa9bde758077cef79326566af"
    sha256 cellar: :any, mojave:        "68f217f8fc16176d81325954ca87f92c62325d7beb8557852acb2c65e3dee052"
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
