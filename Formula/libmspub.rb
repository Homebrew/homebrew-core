class Libmspub < Formula
  desc "Interpret and import Microsoft Publisher content"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libmspub"
  url "https://dev-www.libreoffice.org/src/libmspub/libmspub-0.1.4.tar.xz"
  sha256 "ef36c1a1aabb2ba3b0bedaaafe717bf4480be2ba8de6f3894be5fd3702b013ba"
  license "MPL-2.0"
  revision 13

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libmspub[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7bc328cf9f8886c9fbb18d3fd5a1cb0c6330c17d941372e17f5095c1d3d36118"
    sha256 cellar: :any,                 arm64_monterey: "94da79b408e3d0b1ebcf13bdb30c6228c145335f1ba8e7509492e18429d8e9bc"
    sha256 cellar: :any,                 arm64_big_sur:  "e77f76c818866f04bf253365ad8a880861267f1f5d640f096338efbec174d60f"
    sha256 cellar: :any,                 ventura:        "2b1533aaf31b11c0ddf727683f9c17bf3305c3f7b4634ac59c753a61a6f71d6e"
    sha256 cellar: :any,                 monterey:       "05c0143012b367fbc2c081c4e7000b1df13d3e8aa416cfd6f778ede271cd8e34"
    sha256 cellar: :any,                 big_sur:        "fd5d1981f11da0aab7a72097998832763ae7ba5236fc67de93495b63e961356e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e50ba82f3e5e71c1f6c2aeea355ef2431c24a449b4ceef0c8bb097ac94388b4"
  end

  depends_on "boost" => :build
  depends_on "libwpg" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "librevenge"
  depends_on "libwpd"

  # Fix for missing include needed to build with recent GCC. Remove in the next release.
  # Commit ref: https://git.libreoffice.org/libmspub/+/698bed839c9129fa7a90ca1b5a33bf777bc028d1%5E%21
  patch do
    on_linux do
      url "https://gerrit.libreoffice.org/changes/libmspub~73814/revisions/2/patch?zip"
      sha256 "4c50ba6cc609b64d6769449f3296c26082f470d4011d35ec53599c336387fa38"
    end
  end

  def install
    system "./configure", "--without-docs",
                          "--disable-dependency-tracking",
                          "--enable-static=no",
                          "--disable-werror",
                          "--disable-tests",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <librevenge-stream/librevenge-stream.h>
      #include <libmspub/MSPUBDocument.h>
      int main() {
          librevenge::RVNGStringStream docStream(0, 0);
          libmspub::MSPUBDocument::isSupported(&docStream);
          return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-lrevenge-stream-0.0",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-lmspub-0.1", "-I#{include}/libmspub-0.1",
                    "-L#{lib}", "-L#{Formula["librevenge"].lib}"
    system "./test"
  end
end
