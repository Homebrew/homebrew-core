class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.16.tar.xz"
  sha256 "c04b5d89f3df0dee9772f50197c2602c97c5cdb439b6af539c37bf81b20f47d8"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/msmtp/download/"
    regex(/href=.*?msmtp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "e3c002f51aad6d5fbe7b63a403c85c4f03357fb9e888b107adc07ebe26b91e88"
    sha256 big_sur:       "6c263b2417be9fa52e5dd3e191e0ebc01700d1c84a0e1aee74e8627d2bb8667c"
    sha256 catalina:      "517ec9746a322fccbea429fb43665eb89f8495f65c1c355ca92ca582bf5aea49"
    sha256 mojave:        "d11af3fb5a135e6f7cd14a680c4cd9e9df021c88321bc3ae7dddb48711340406"
    sha256 x86_64_linux:  "8560c7eaed75bbc84f3bd6533864155fdce07e95c3b948663316df3dd5c13d98"
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
