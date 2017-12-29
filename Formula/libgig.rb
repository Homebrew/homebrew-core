class Libgig < Formula
  desc "Library for Gigasampler and DLS (Downloadable Sounds) Level 1/2 files"
  homepage "https://www.linuxsampler.org/libgig/"
  url "https://download.linuxsampler.org/packages/libgig-4.1.0.tar.bz2"
  sha256 "06a280278a323963042acdf13b092644cceb43ef367fcbb9ca7bbedff132bd0b"

  bottle do
    cellar :any
    sha256 "8d78da0e18660f690073643fec535ab972b7ab34a53136c3ab2c6d12063437c9" => :high_sierra
    sha256 "d8f007c17aa5098d5f7a05d60403c141d21a66a78754639402549a4da2f6e624" => :sierra
    sha256 "3f669e4d7c16bd6eff156c5e36c62969e68c06177a4518424dab1c7ed12e7f43" => :el_capitan
    sha256 "b1483446d24800cffa43ff8d3fa94d0c2ee906fefbc84cf84ea93d046e58b2f4" => :yosemite
    sha256 "52cfa0b813caee97ecbae5128f39329a0124ba60f3328c1db2bf296e839403ed" => :mavericks
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
