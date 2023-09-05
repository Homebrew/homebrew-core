class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.24.tar.xz"
  sha256 "bd6644b1aaab17d61b86647993e3efad860b23c54283b00ddc579c1f5110aa59"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/msmtp/download/"
    regex(/href=.*?msmtp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "5f5d5357335fe1c163aff3daede12982893e0510345d9a7fb1b2ffb9e9b312da"
    sha256 arm64_monterey: "6c7e4cca084ef1440c202a24e1bc2bbd4e87fb144b20614b90f0f4dec33283c3"
    sha256 arm64_big_sur:  "c2244185a32bc16bb6cac7f7094cb379fc925f9d0e3dedfef4761f0a012f0fba"
    sha256 ventura:        "6cdea01606ab43764a97082cac4e486e693b557a739ab0c5b0865a9d0bac7f51"
    sha256 monterey:       "28aa80afe8886e3d60f6b5e08bf63fb0c94e8937f0d422a3e265d76f44405620"
    sha256 big_sur:        "04424ed650cf2330a5ff7e3cf65e2476dfae18d9b2bb961d99c2a83fea8ad8aa"
    sha256 x86_64_linux:   "286904b8002879ca37c1d52a30b823e137322115989c1049363c830f4a449a78"
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
