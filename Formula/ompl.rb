class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "http://ompl.kavrakilab.org"
  url "https://bitbucket.org/ompl/ompl/downloads/ompl-1.3.0-Source.tar.gz"
  sha256 "87ab32541a461daca529d7a2d1aecd8d3f1df2d403756b7a7f98b6824be2d74e"

  bottle do
    sha256 "3dc98f4ee2f1d891e9262244e62af56deee44a35a91d2e66e6db946d4cb53047" => :sierra
    sha256 "d2e172a1cc14a6c6a7e984b006a5f7a3d18f4a12415d21749e66fa208af67824" => :el_capitan
    sha256 "eb966f1601007bf76e4b53108a039beb703f8fb08f571ff153e0eac7e1ffdc2e" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen" => :optional
  depends_on "ode" => :optional

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <ompl/base/spaces/RealVectorBounds.h>
      #include <cassert>
      int main(int argc, char *argv[]) {
        ompl::base::RealVectorBounds bounds(3);
        bounds.setLow(0);
        bounds.setHigh(5);
        assert(bounds.getVolume() == 5 * 5 * 5);
      }
    EOS

    system ENV.cc, "test.cpp", "-L#{lib}", "-lompl", "-lstdc++", "-o", "test"
    system "./test"
  end
end
