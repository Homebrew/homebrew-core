class Blitz < Formula
  desc "C++ class library for scientific computing"
  homepage "https://blitz.sourceforge.io"
  url "https://downloads.sourceforge.net/project/blitz/blitz/Blitz++%200.10/blitz-0.10.tar.gz"
  sha256 "804ef0e6911d43642a2ea1894e47c6007e4c185c866a7d68bad1e4c8ac4e6f94"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f8eac429778e92f80e83d9f013e4b5ebc162e458a77af592cfe4f2de820b1bfa" => :catalina
    sha256 "1d88c433d1c5dc863d670358624cc3d733f042cdb052848c673d5eafa8a6dc33" => :mojave
    sha256 "1fbcdb2453e10ef03721f965050244519743a6161dfc581bda663597ecf44595" => :high_sierra
    sha256 "b676b24071752779faadf53d71b53b0c632b8ba62d1cd7c1f90d40ee5b13a85b" => :sierra
  end

  head do
    url "https://github.com/blitzpp/blitz.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-fi" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--infodir=#{info}",
                          "--enable-shared",
                          "--disable-doxygen",
                          "--disable-dot",
                          "--prefix=#{prefix}"
    system "make", "install"
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
