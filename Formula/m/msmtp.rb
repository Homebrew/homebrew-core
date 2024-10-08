class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.27.tar.xz"
  sha256 "94030580a63a747faa0a3b9b1b264ae355aad33a4d94b832bfeb5b21633c965e"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/msmtp/download/"
    regex(/href=.*?msmtp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "ec7542e254bcd4e2498f075b2aa137490d3fb407d4bf7bd84d5a480abc60562b"
    sha256 arm64_sonoma:  "6b444a784108290a0d998b7cfa77ae51ce8ecd7e3f17b4200dc751d6de7f625c"
    sha256 arm64_ventura: "87957d05e326d582c7f69e0682d0f5d217e4df5f31114f2a3cb9551984a0603e"
    sha256 sonoma:        "7dff928882d705718325cc8c802d67284decc9d9db8d8911e062241411acae21"
    sha256 ventura:       "6bdc0b6dd5273b34e5c856eaa08ab131d4e7b6430e08bfdaca1b9673cd20899d"
    sha256 x86_64_linux:  "c961aa0f18c58586f17e20f1b8ca3e05cd1ad7e4d33e077b99de2bfc5b1dd50e"
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
