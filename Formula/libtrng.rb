class Libtrng < Formula
  desc "Tina's Random Number Generator Library"
  homepage "https://www.numbercrunch.de/trng/"
  url "https://www.numbercrunch.de/trng/trng-4.20.tar.gz"
  sha256 "8cffd03392a3e498fe9f93ccfa9ff0c9eacf9fd9d33e3655123852d701bbacbc"

  bottle do
    cellar :any
    sha256 "db8bf329be7d9ed42cc55144ee0ac1b3f44976fd05bf208003860da9128480d5" => :catalina
    sha256 "5ec98840f9e339911ef1cd9d666160005ad73dc9191e8954d5f96bead5ae404c" => :mojave
    sha256 "c6ed745a330d0da3123467cb19dd6f4c8f6871aed54b4f6addd813271599a2d6" => :high_sierra
    sha256 "54e596853cd0ea1b49dd62d0d3fc5f559063572a6f19e3fb26ef09ed19a01564" => :sierra
    sha256 "e821f8b59abe5f15689ac8720539bd258eab64f83ecfa6047406e4c11884bdef" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <trng/yarn2.hpp>
      #include <trng/normal_dist.hpp>
      int main()
      {
        trng::yarn2 R;
        trng::normal_dist<> normal(6.0, 2.0);
        (void)normal(R);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-ltrng4"
    system "./test"
  end
end
