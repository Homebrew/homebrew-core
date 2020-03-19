class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.9.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.9.tar.gz"
  sha256 "64a16dcdbd08ac3dfcde3b898871e9cfbb604bebfb8d4aa43d68b7ea86aabbf5"

  bottle do
    sha256 "35f9c47a5686e1d32fbb262cfe107713724968c1803ff514c9af42cc2d0b4814" => :catalina
    sha256 "7674dc436a80ad930a23ea27fc5e68cccafa98f1f14ccaa14a67f363cf94a004" => :mojave
    sha256 "e498a1ff3f1b8d80dd04425e13b7f74ccd18736743e063315347c242e0b67b79" => :high_sierra
  end

  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "libtool"
  depends_on "readline"

  def install
    system "./configure", "--disable-mh",
                          "--prefix=#{prefix}",
                          "--without-fribidi",
                          "--without-gdbm",
                          "--without-guile",
                          "--without-tokyocabinet"
    system "make", "PYTHON_LIBS=-undefined dynamic_lookup", "install"
  end

  test do
    system "#{bin}/movemail", "--version"
  end
end
