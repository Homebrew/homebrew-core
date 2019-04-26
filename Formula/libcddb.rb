class Libcddb < Formula
  desc "CDDB server access library"
  homepage "https://libcddb.sourceforge.io/"
  url "https://downloads.sourceforge.net/libcddb/libcddb-1.3.2.tar.bz2"
  sha256 "35ce0ee1741ea38def304ddfe84a958901413aa829698357f0bee5bb8f0a223b"
  revision 4

  bottle do
    cellar :any
    sha256 "2eb96af074a3f8dc8babf689481d9be863c0e79445499a473f94c57773381983" => :mojave
    sha256 "f6f41c88a20822be86c07ce27b0f426d3c34d4d420c77d35ff457291c7ad3ada" => :high_sierra
    sha256 "bc93037789abf90bd060a9f6f27af23b2fabb7980c43f5d4a93835469442466a" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libcdio"

  def install
    if MacOS.version == :yosemite && MacOS::Xcode.version >= "7.0"
      ENV.delete("SDKROOT")
    end

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
