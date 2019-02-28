class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.22.tar.xz"
  sha256 "ee7868d7ba0498cf2cccefe107d7efee7f2571098806bba2aed5a159db801318"
  head "https://github.com/MidnightCommander/mc.git"

  bottle do
    sha256 "752b14547cba6c6165e15e1e39cbc1d643482ba84640948be02d1e7f7a7388e2" => :mojave
    sha256 "7c715413595dee9cb2338a492f2ab467bdcba48d240c8b4773d7c967508d0e4a" => :high_sierra
    sha256 "d6ffb05221808b6d37b59793cb4829755faeaca0697f335bf4699423760842b6" => :sierra
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
