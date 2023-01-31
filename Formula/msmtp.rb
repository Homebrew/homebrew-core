class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.23.tar.xz"
  sha256 "cf04c16b099b3d414db4b5b93fc5ed9d46aad564c81a352aa107a33964c356b8"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/msmtp/download/"
    regex(/href=.*?msmtp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "5b7bd15f68a6de10c3abe8fe08c8b64c4283f72a58ca05369b8d3cea0f43329c"
    sha256 arm64_monterey: "0cc3a6d3daed4b0fd15e70520cb120efd82f7f1210560b39b8e9c7854e16f053"
    sha256 arm64_big_sur:  "f2362f4e117b58a5d4578e29b67ddbfcf761b852becd2147ef2cddf375d83d24"
    sha256 ventura:        "a575d0c47546e4bb0bd78a9b12a4e0fc3ebc72c4fe63d2ef9d76da691aa48269"
    sha256 monterey:       "d87aaa7e55968b4128e2329c45f767c78fb8f13e18344d067f849aad12b080e8"
    sha256 big_sur:        "32932f4e3b8c9dfe9efe9eaa3414cb5f991669ffe8c5bca8768270b2a9f42408"
    sha256 x86_64_linux:   "ebf44d0aff2e946cacc349948aab422c1eeec885e70fc4be022cd1c29b9b4322"
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
