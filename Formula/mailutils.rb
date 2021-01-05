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
    rebuild 1
    sha256 "e0694e4e8cfb3bfdd5d3e228142a314cc321bf82308d23148126b8ca488d1b41" => :big_sur
    sha256 "c855fc17cf334a9db2d7f3d1ed44d4484c3943ff273154b41f0013d477cf8be4" => :arm64_big_sur
    sha256 "ec93701d653bb3d54d47d795b762a5a4491901b28fa12c5de7c2127d32e2bcf6" => :catalina
    sha256 "a3bd339cc91ad0d8bdb8d68cc3aea0b89b183b5615d25eeb73f6757ed874ddf6" => :mojave
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
