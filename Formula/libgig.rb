class Libgig < Formula
  desc "Library for Gigasampler and DLS (Downloadable Sounds) Level 1/2 files"
  homepage "https://www.linuxsampler.org/libgig/"
  url "https://download.linuxsampler.org/packages/libgig-4.2.0.tar.bz2"
  sha256 "16229a46138b101eb9eda042c66d2cd652b1b3c9925a7d9577d52f2282f745ff"

  bottle do
    cellar :any
    sha256 "538a70194a691a8a8bd09095736f6aba4c6de6ed4f03bed512726372e41bd7a4" => :catalina
    sha256 "5b4c6358356d805ce317ed31014a8235fc79bad43a80b6c03deb63abe8bc1aac" => :mojave
    sha256 "050bb14b4914d0c08e2a8c192b5254ecb77f9239b8f516022260f5356a8ab947" => :high_sierra
    sha256 "6e7d4ee68ce41305b89c91b2c7e34eeb57f45c6ea5d991beb0e66aac76a5d458" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libsndfile"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libgig/gig.h>
      #include <iostream>
      using namespace std;

      int main()
      {
        cout << gig::libraryName() << endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}/libgig", "-lgig", "-o", "test"
    assert_match "libgig", shell_output("./test")
  end
end
