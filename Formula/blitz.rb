class Blitz < Formula
  desc "Multi-dimensional array library for C++"
  homepage "https://github.com/blitzpp/blitz/wiki"
  url "https://github.com/blitzpp/blitz/archive/1.0.2.tar.gz"
  sha256 "500db9c3b2617e1f03d0e548977aec10d36811ba1c43bb5ef250c0e3853ae1c2"
  head "https://github.com/blitzpp/blitz.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f8eac429778e92f80e83d9f013e4b5ebc162e458a77af592cfe4f2de820b1bfa" => :catalina
    sha256 "1d88c433d1c5dc863d670358624cc3d733f042cdb052848c673d5eafa8a6dc33" => :mojave
    sha256 "1fbcdb2453e10ef03721f965050244519743a6161dfc581bda663597ecf44595" => :high_sierra
    sha256 "b676b24071752779faadf53d71b53b0c632b8ba62d1cd7c1f90d40ee5b13a85b" => :sierra
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
