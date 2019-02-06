class Libfreefare < Formula
  desc "API for MIFARE card manipulations"
  homepage "https://github.com/nfc-tools/libfreefare"
  url "https://github.com/nfc-tools/libfreefare/releases/download/libfreefare-0.4.0/libfreefare-0.4.0.tar.bz2"
  sha256 "bfa31d14a99a1247f5ed49195d6373de512e3eb75bf1627658b40cf7f876bc64"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "953fe3418c5992478db9870f2b8dbf40d47e232ac893b914abf0ed22d5b2e135" => :mojave
    sha256 "745df5e971fa587181aedac8a82a534b7a7a882db37214f41a11abcfb7f346ea" => :high_sierra
    sha256 "db7b9483be4a65d146fdba8211c8280c65eacb1d7537b1f149a2ef10433598ae" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libnfc"
  depends_on "openssl"

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
