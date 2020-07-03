class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.24.tar.xz"
  sha256 "859f1cc070450bf6eb4d319ffcb6a5ac29deb0ac0d81559fb2e71242b1176d46"

  bottle do
    sha256 "c6adcb70e949c89ba12ba91fffb89ad00c55e8c3a063ae6d01954a02a84512f2" => :catalina
    sha256 "2e3e95bd852f0edd7069b09ff24e897e94bb495f3b852230f7cc3400acfc2d9a" => :mojave
    sha256 "2e888d8d8cec7a0c881d0df09f5662080494f89e1871fbcccf30e9a0cc18aa1b" => :high_sierra
  end

  head do
    url "https://github.com/MidnightCommander/mc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libssh2"
  depends_on "openssl@1.1"
  depends_on "s-lang"

  conflicts_with "minio-mc", :because => "both install an `mc` binary"

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
    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "GNU Midnight Commander", shell_output("#{bin}/mc --version")
  end
end
