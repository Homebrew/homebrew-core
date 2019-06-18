class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.22.tar.xz"
  sha256 "ee7868d7ba0498cf2cccefe107d7efee7f2571098806bba2aed5a159db801318"
  revision 1
  head "https://github.com/MidnightCommander/mc.git"

  bottle do
    sha256 "c1b8c5c6f30a67ab06e29a441e1b33f2b2f351e1cac064d005c58a2061d3fc2d" => :mojave
    sha256 "ab2a0274dad5bdb3073e9331ea29f69179735a0ed424eb02b6723d40e074ba80" => :high_sierra
    sha256 "5fdca1bab0f0d9b430a743041b6567da126e3bd22e0d4433df58e1afe3404d60" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libssh2"
  depends_on "openssl"
  depends_on "s-lang"

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

    # Fix compilation bug on macOS 10.13 by pretending we don't have utimensat()
    # https://github.com/MidnightCommander/mc/pull/130
    ENV["ac_cv_func_utimensat"] = "no" if MacOS.version >= :high_sierra

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "GNU Midnight Commander", shell_output("#{bin}/mc --version")
  end
end
