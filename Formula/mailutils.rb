class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.11.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.11.1.tar.gz"
  sha256 "f075803a55b43c304b90bad6d31bf8aa09c4f81037b5f88e0f2d07192e98165a"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "687c53f8c730b0de5464c6459a028d5b297e6b6c4543b1e4c1f686cda806b072" => :big_sur
    sha256 "f16f6ae8c4081e7c37016b14ed028834953ea7bd4d25d93b6263f17cc56751c6" => :arm64_big_sur
    sha256 "8b0f0328d61b1a3d5b6d7bf0d395eece7ad6d267419c705e3818ad8b39ed5f39" => :catalina
    sha256 "2d7b9ac9fec5c1dbe554b5fc4f866911b3cdc607a503b8968472fe700f7a1b20" => :mojave
  end

  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "libtool"
  depends_on "readline"

  def install
    system "./configure", "--disable-mh",
                          "--prefix=#{prefix}",
                          "--without-fribidi",
                          "--without-gdbm",
                          "--without-guile",
                          "--without-tokyocabinet"
    system "make", "PYTHON_LIBS=-undefined dynamic_lookup", "install"
  end

  test do
    system "#{bin}/movemail", "--version"
  end
end
