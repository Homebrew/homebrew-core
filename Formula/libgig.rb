class Libgig < Formula
  desc "Library for Gigasampler and DLS (Downloadable Sounds) Level 1/2 files"
  homepage "https://www.linuxsampler.org/libgig/"
  url "https://download.linuxsampler.org/packages/libgig-4.2.0.tar.bz2"
  sha256 "16229a46138b101eb9eda042c66d2cd652b1b3c9925a7d9577d52f2282f745ff"

  bottle do
    cellar :any
    sha256 "5d574860bf0fe0c58cdbf981946f081bc0925867310d269e27599949191e405a" => :mojave
    sha256 "e76d0051885444442b71bd65228a5b777c83640d4088c6d8c07ef56a88ef68d6" => :high_sierra
    sha256 "52a948f55300ca0b67e346fa987c4967cabcaf0c7e43698c86ef4dd2f5add67d" => :sierra
    sha256 "ead7f19fe837a7b38ef753993ad3c73b36a07269d1c12c9d1220204fa46a046a" => :el_capitan
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
