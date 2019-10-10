class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.5.tar.xz"
  sha256 "1613daced9c47b8c028224fc076799c2a4d72923e242be4e9e5c984cbbbb9f39"

  bottle do
    rebuild 1
    sha256 "99970d911f8d68c08d77a191880f18f20b79a525881925cb236eebd5ecdf3917" => :catalina
    sha256 "7fb3d22477c6b338159bf8fa5b21c764e7add5e941b03fbbe293c08d3413b13e" => :mojave
    sha256 "56d46b248e6e5636ddea99f7651ba0b8fe20b557a82ddf2610c7800b5f2e371e" => :high_sierra
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
