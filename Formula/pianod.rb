class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod/pianod-176.tar.gz"
  sha256 "4f3be12daef1adb3bcbbcf8ec529abf0ac018e03140be9c5b0f1203d6e1b9bf0"
  revision 1

  bottle do
    sha256 "01b47d23674efaf3ddefced7f4dfee0db683d956ea455ebd9a8bd0e8f3cf7d9d" => :mojave
    sha256 "d0aa3614b2b70ca8140820bd059c1ebdbb54799b69ab6346f36a42a4dac600de" => :high_sierra
    sha256 "fe7983c06b7fe6163792e7e0eeed5990b9d09e44ffc19d0c62808503ca409f5f" => :sierra
    sha256 "3ed572ebaf767ba924cc7b402362775b77a19cd69337f940344988f86d2a1936" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "faad2"
  depends_on "gnutls"
  depends_on "json-c"
  depends_on "libao"
  depends_on "libgcrypt"
  depends_on "mad"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pianod", "-v"
  end
end
