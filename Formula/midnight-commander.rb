class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.16.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/mc/mc_4.8.16.orig.tar.xz"
  sha256 "bbbcbe3097d3160f865d24aa38ff122f1c59752b5ef153ca4ade5ac0f82b7020"

  head "https://github.com/MidnightCommander/mc.git"

  bottle do
    revision 1
    sha256 "04b0873fa4f085de596d84120d4fa212d37186d53b9da0a7c3837b142647d840" => :el_capitan
    sha256 "3506e4a2c6c10b4f2f498957181fce72d5420ce198c381d64df320060cda1da9" => :yosemite
    sha256 "fd4cd670dc22f75edb9a492542619427f0201fe1872c343ff8e42ba4f0b9e68a" => :mavericks
  end

  option "without-nls", "Build without Native Language Support"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl"
  depends_on "s-lang"
  depends_on "libssh2"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --without-x
      --with-screen=slang
      --enable-vfs-sftp
    ]

    args << "--disable-nls" if build.without? "nls"

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "GNU Midnight Commander", shell_output("#{bin}/mc --version")
  end
end
