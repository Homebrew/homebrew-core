class Libfreefare < Formula
  desc "API for MIFARE card manipulations"
  homepage "https://github.com/nfc-tools/libfreefare"
  url "https://github.com/nfc-tools/libfreefare/releases/download/libfreefare-0.4.0/libfreefare-0.4.0.tar.bz2"
  sha256 "bfa31d14a99a1247f5ed49195d6373de512e3eb75bf1627658b40cf7f876bc64"
  revision 2

  bottle do
    cellar :any
    sha256 "e9432f6847992d848ab9ff220e5f7309672933a857987b1f49d5533c0c998af5" => :catalina
    sha256 "cb3dedfc77ded9e44680a7c7f68ab9fc20d7cb2042bde58494968f011354eb74" => :mojave
    sha256 "d3d40b88ac6049ea3eb2f3afc96dee6608425bd46526b5e15f264c9b9c8fba99" => :high_sierra
    sha256 "4f75161d80be443a364a7d594dd9c627d6c253edbb856241dff1f9b73af3fec3" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libnfc"
  depends_on "openssl@1.1"

  # Upstream commit for endianness-related functions, fixes
  # https://github.com/nfc-tools/libfreefare/issues/55
  patch do
    url "https://github.com/nfc-tools/libfreefare/commit/358df775.diff?full_index=1"
    sha256 "54cace0b9f7be073ba96ba1ae04fba8882a5ce99100a7b707498b9d2bfb0a660"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <freefare.h>
      int main() {
        mifare_desfire_aid_new(0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lfreefare", "-o", "test"
    system "./test"
  end
end
