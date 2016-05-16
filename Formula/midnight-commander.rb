class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.17.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/mc/mc_4.8.17.orig.tar.xz"
  sha256 "0447bdddc0baa81866e66f50f9a545d29d6eebb68b0ab46c98d8fddd2bf4e44d"

  head "https://github.com/MidnightCommander/mc.git"

  bottle do
    sha256 "7e5e8dc78e8dd86d8fa51091c1912326fb5d85d78291614028b0da08240d008d" => :el_capitan
    sha256 "3c5aab63ee0ade919670397602399ec06b0873ae682cc81abe3920d6af8b5527" => :yosemite
    sha256 "dc8930e3f21e8c6bbbfb57c9deb76c277ea5cfac28057c48e3c35465fe782c05" => :mavericks
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
