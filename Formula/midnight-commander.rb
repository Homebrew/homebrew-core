class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.18.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/mc/mc_4.8.18.orig.tar.xz"
  sha256 "f7636815c987c1719c4f5de2dcd156a0e7d097b1d10e4466d2bdead343d5bece"
  head "https://github.com/MidnightCommander/mc.git"

  bottle do
    sha256 "17a0c9039bd8f1c862ea282a3305d91b75759a3c6200056e5e1c4ff38ba1e9ff" => :sierra
    sha256 "7f0bc00fdfa069c8139f3aebff3621824dfa4b5f6c6b4688336162615a2bb4fa" => :el_capitan
    sha256 "033b658071cefd0af127e1a9a88cf5bddd9bafc50b583df9f6f850f2a457d34d" => :yosemite
  end

  option "without-nls", "Build without Native Language Support"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl"
  depends_on "s-lang"
  depends_on "libssh2"

  conflicts_with "minio-mc", :because => "Both install a `mc` binary"

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
