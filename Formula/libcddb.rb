class Libcddb < Formula
  desc "CDDB server access library"
  homepage "https://libcddb.sourceforge.io/"
  url "https://downloads.sourceforge.net/libcddb/libcddb-1.3.2.tar.bz2"
  sha256 "35ce0ee1741ea38def304ddfe84a958901413aa829698357f0bee5bb8f0a223b"
  revision 4

  bottle do
    cellar :any
    rebuild 1
    sha256 "7f1c41ce153e0550edac0073eeaf3a82d430fdd6b8e1c6d766459f81905b5b1e" => :catalina
    sha256 "4a54605d856a52362d5b3a76a20872c72df138dca4b19595ffbdd6bc44e210be" => :mojave
    sha256 "fcb848ca3b114f197ca52850d56a63b298fad61b9ee968496ddc450d969c3078" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libcdio"

  def install
    ENV.delete("SDKROOT") if MacOS.version == :yosemite && MacOS::Xcode.version >= "7.0"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <cddb/cddb.h>
      int main(void) {
        cddb_track_t *track = cddb_track_new();
        cddb_track_destroy(track);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcddb", "-o", "test"
    system "./test"
  end
end
