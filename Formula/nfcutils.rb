class Nfcutils < Formula
  desc "Near Field Communication (NFC) tools under POSIX systems"
  homepage "https://github.com/nfc-tools/nfcutils"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/nfc-tools/nfcutils-0.3.2.tar.gz"
  sha256 "dea258774bd08c8b7ff65e9bed2a449b24ed8736326b1bb83610248e697c7f1b"
  license "GPL-3.0"
  revision 1

  bottle do
    cellar :any
    sha256 "963e5bf77bc285e81b9f7480f8b0362c73e5138bced77608043742df6e0992cd" => :catalina
    sha256 "972af2e69529bde17b450d36ccfbb4b9d124c59beb7bb4d69a9c63b76f7cff58" => :mojave
    sha256 "44dc64d49e9edc0c7b8f22c7f259262d5706f83bb452099b968b9f3576047367" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libnfc"
  depends_on "libusb"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
