class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.21.tar.xz"
  sha256 "8f37e546ac7c31c9c203a03b1c1d6cb2d2f623a300b86badfd367e5559fe148c"
  head "https://github.com/MidnightCommander/mc.git"

  bottle do
    rebuild 1
    sha256 "f3d9cb2444cf1f8f757afe0c70a7c4b737718144bd667926f49fbbd35a7a290f" => :mojave
    sha256 "d810c0aed2f4007b94776895822c9dd79242a10c6bd6bc6507b6f46c4bb5a9fb" => :high_sierra
    sha256 "08bd22ecf0dd7183e36f01f44d6c5fd7c8ee759c08121ecaed1be19d87017247" => :sierra
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
