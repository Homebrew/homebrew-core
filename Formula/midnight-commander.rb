class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.17.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/mc/mc_4.8.17.orig.tar.xz"
  sha256 "0447bdddc0baa81866e66f50f9a545d29d6eebb68b0ab46c98d8fddd2bf4e44d"

  head "https://github.com/MidnightCommander/mc.git"

  bottle do
    sha256 "c83232919ef7d0fabd5a6264c5f32f4dd229925b00e2e453218c383ebbe47a6e" => :el_capitan
    sha256 "9b2472d105b8035dfec599472f33e4557bf0f29cfc3773d2f54045d18be1e105" => :yosemite
    sha256 "50c3e2e79bd010a44987e8246a0456714da542caf27e1cd641d984f7f5751d04" => :mavericks
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
