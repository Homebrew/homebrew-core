class Erfa < Formula
  desc "Essential Routines for Fundamental Astronomy"
  homepage "https://github.com/liberfa/erfa"
  url "https://github.com/liberfa/erfa/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "d5469fbd0b212b3c7270c1da15c9bd82f37da9218fc89627f98283d27b416cbf"
  license "SOFA Software License"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <erfa.h>
      int main() {
        double p[3] = {1, 2, 3};
        eraZp(p);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lerfa", "-o", "test"
    system "./test"
  end
end
