class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.22.tar.xz"
  sha256 "1b04206286a5b82622335e4eb09e17074368b7288e53d134543cbbc6b79ea3e7"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/msmtp/download/"
    regex(/href=.*?msmtp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "998546c39f503352cfcda5e4b67d514b693eecb531fbb14c49122b425e4b192c"
    sha256 arm64_monterey: "92d52d20ef071b7de5dcd5be20655d29cce0b5704bf51e566b589174d0671094"
    sha256 arm64_big_sur:  "0cf7ac0320339689f3746094f2504e608621e270fbfb213bbe25cff544b11a1f"
    sha256 ventura:        "be8d73253cacaf969572d9aa2a469d27c6efe8ec682282dd0132cd44e0160f6f"
    sha256 monterey:       "30141e954634d0da2cd15fcef4292d6bc424ad1d822f5995e71f41f7b6efb50a"
    sha256 big_sur:        "16c4c861b923ddfcc1633f9960d8676968b4bf4dd4fde4977972fd04311d394f"
    sha256 catalina:       "8fe09ebdfcddedd9b7bd5e7143a21be824fc5c6cd7ccdde3fd34e4d0bf2069cf"
    sha256 x86_64_linux:   "06310653bd5d605a7695ccc4e66e269b91e2a4767daffa46cb4bab227ed9ae59"
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
