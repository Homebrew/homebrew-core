class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.25.tar.xz"
  sha256 "2dfe1dbbb397d26fe0b0b6b2e9cd2efdf9d72dd42d18e70d7f363ada2652d738"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/msmtp/download/"
    regex(/href=.*?msmtp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "2db770299573a11409efc9107eb9b70b0b92fa346eb70bcb719e0d14b3552aa6"
    sha256 arm64_ventura:  "be963c8b3c8f6dc98f00cc0070916c033186a789d7c14d5e6c06a8243f8c54e1"
    sha256 arm64_monterey: "eddccee3f5c54a14f747249ce62029ab1609962b4df80706e6cc7baecf1fc067"
    sha256 sonoma:         "c2386b2f34d62ce01f230f27f41536073ad27542eebba26f1f511f269f844cf5"
    sha256 ventura:        "80f7cad00e988855092b5ce3d9071f755ef2c14461f39d406f2eb23537158142"
    sha256 monterey:       "280c817c144c9a21290822fe36220f7cf072912cd209ee25dd842b821ecb1d45"
    sha256 x86_64_linux:   "f9d7fcb222e909d6cff9225972c69014a5f3e18ec585a2891227815a8db2eafe"
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
