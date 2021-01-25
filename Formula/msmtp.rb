class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.14.tar.xz"
  sha256 "d56f065d711486e9c234618515a02a48a48dab4051b34f3e108fbecb6fb773b4"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/msmtp/download/"
    regex(/href=.*?msmtp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 "1442de74b62c774f632930813305a7ef0e18c616a0aef8606173365f4507fe8c" => :big_sur
    sha256 "c53034858791caf4344700721fd329a465c24126f288faf841822ab122379e63" => :arm64_big_sur
    sha256 "435be4434e3f91eb88a2a8ad30657c755e87394a31745e3753514daa987dea70" => :catalina
    sha256 "1e34aee670402e13245b56e1f9d8e33826019b04474c56c86617fc6f06ab82c5" => :mojave
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
