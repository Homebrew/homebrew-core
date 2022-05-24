class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.20.tar.xz"
  sha256 "d93ae2aafc0f48af7dc9d0b394df1bb800588b8b4e8d096d8b3cf225344eb111"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/msmtp/download/"
    regex(/href=.*?msmtp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "8508ac9dfbeac3274e8b90b458ce4d23e763d69dcda5c433f95a26c2850549d0"
    sha256 arm64_big_sur:  "b5dcd7d18d087c04bde608df5229416315c15a7b48f2551a20ae1bf443b0936d"
    sha256 monterey:       "a61abd779581e23ffee661d226448a5897e16d1ba1b7cbdaec926d7711127e9a"
    sha256 big_sur:        "f354e83b318837c07c0dddf7f194f3b7b777017616bc7ebce5a79bb037163c8b"
    sha256 catalina:       "34bc2d711bcf14a0f42d2fd9a5500b9fa3e662ea0387de45d3dd1907638e1e73"
    sha256 x86_64_linux:   "758636ba630b46c2edc955438a6828ececd7b2ce79d3960cc9467d80aa7859f5"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libidn2"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--with-macosx-keyring"
    system "make", "install"
    (pkgshare/"scripts").install "scripts/msmtpq"
  end

  test do
    system bin/"msmtp", "--help"
  end
end
