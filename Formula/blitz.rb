class Blitz < Formula
  desc "Multi-dimensional array library for C++"
  homepage "https://github.com/blitzpp/blitz/wiki"
  url "https://github.com/blitzpp/blitz/archive/1.0.2.tar.gz"
  sha256 "500db9c3b2617e1f03d0e548977aec10d36811ba1c43bb5ef250c0e3853ae1c2"
  license "Artistic-2.0"
  head "https://github.com/blitzpp/blitz.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c12b81ef4cb76e7ab76b557ef4a57ac431a6a39ab63bce8f1d786a6e2c316140"
    sha256 cellar: :any,                 arm64_monterey: "3403559216a7fe96f965537612fdbe8852810870a54c2ba96b6c0d15c9d03726"
    sha256 cellar: :any,                 arm64_big_sur:  "0b04264665a05ca8b018a1f9b8e7452297d675b5bb5b50f49af2dd5176de462e"
    sha256 cellar: :any,                 ventura:        "fd5d3fdf22093032fd588b6de174f4c55d7b34bba8badfab58a244bad118c34b"
    sha256 cellar: :any,                 monterey:       "d18fe13200228947c919659133af057d66da2ccbcbf65febd057a612b2014a8d"
    sha256 cellar: :any,                 big_sur:        "eaf888ad2387b3aabccdc8ba82104b942dfa91b058b335449a7bdeb26213ce7d"
    sha256 cellar: :any,                 catalina:       "2bfa3e5a52f0f51e9e02c84f10f804093b7080c158b3376f330dd51c0f9e3d23"
    sha256 cellar: :any,                 mojave:         "a06052c039592fe7b41face9c72d715ba0602456a9df07a40a472d3ceba02c00"
    sha256 cellar: :any,                 high_sierra:    "79901f790ea3583942a72ababfba3dc6569169f228b0428c047da52f1f99c02d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69b643943846376a48b8cf266f639fff523ad74430a2e784c2bfdfab21137179"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "lib"
      system "make", "install"
    end
  end

  test do
    (testpath/"testfile.cpp").write <<~EOS
      #include <blitz/array.h>
      #include <cstdlib>
      using namespace blitz;
      int main(){
        Array<float,2> A(3,1);
        A = 17, 2, 97;
        cout << "A = " << A << endl;
        return 0;}
    EOS
    system ENV.cxx, "testfile.cpp", "-o", "testfile"
    output = shell_output("./testfile")
    var = "/A\ =\ \(0,2\)\ x\ \(0,0\)\n\[\ 17\ \n\ \ 2\ \n\ \ 97\ \]\n\n/"
    assert_match output, var
  end
end
