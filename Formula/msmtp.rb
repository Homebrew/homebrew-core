class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.7.tar.xz"
  sha256 "9a53bcdc244ec5b1a806934ecc7746d9d09db581f587bedf597e9da2f48c51f1"

  bottle do
    sha256 "196849aebd2d300df9fa340ef5d3d18aaf77a287f987026d902492b9de376846" => :catalina
    sha256 "0b0fd5d2e48093d4a5075cfa405d86d27b0d9a40dde771232b7d8f9ac5a3d746" => :mojave
    sha256 "791cd880a93f132c0950b7061a3ad2902ae73587715160af2604ab3346ad312a" => :high_sierra
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
