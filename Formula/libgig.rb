class Libgig < Formula
  desc "Library for Gigasampler and DLS (Downloadable Sounds) Level 1/2 files"
  homepage "https://www.linuxsampler.org/libgig/"
  url "https://download.linuxsampler.org/packages/libgig-4.1.0.tar.bz2"
  sha256 "06a280278a323963042acdf13b092644cceb43ef367fcbb9ca7bbedff132bd0b"

  bottle do
    cellar :any
    sha256 "e76d0051885444442b71bd65228a5b777c83640d4088c6d8c07ef56a88ef68d6" => :high_sierra
    sha256 "52a948f55300ca0b67e346fa987c4967cabcaf0c7e43698c86ef4dd2f5add67d" => :sierra
    sha256 "ead7f19fe837a7b38ef753993ad3c73b36a07269d1c12c9d1220204fa46a046a" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libsndfile"

  def install
    # parallel make does not work, fixed in next version (4.0.0)
    ENV.deparallelize
    # link with CoreFoundation, default in next version (4.0.0)
    ENV.append "LDFLAGS", "-framework CoreFoundation"

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
