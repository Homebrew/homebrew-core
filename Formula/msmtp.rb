class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.12.tar.xz"
  sha256 "a86fef9477339923afefe974988a38e32d0feb90dfeeb88f7f55aac356a96354"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/msmtp/download/"
    regex(/href=.*?msmtp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "0d8168fa3b80b579fac391f7f7f15a1f62cd313360942727984192bd0d0a8395" => :catalina
    sha256 "414f950b8fee308081e67bd90ee5b87657551a860125a3daeafc293c466347ab" => :mojave
    sha256 "da7db756331f0a697451f982f62269cac17395fa5620b02de97381a4a8a6ce2d" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --with-macosx-keyring
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
    (pkgshare/"scripts").install "scripts/msmtpq"
  end

  test do
    system bin/"msmtp", "--help"
  end
end
