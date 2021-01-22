class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.26.tar.xz"
  mirror "https://ftp.osuosl.org/pub/midnightcommander/mc-4.8.26.tar.xz"
  sha256 "c6deadc50595f2d9a22dc6c299a9f28b393e358346ebf6ca444a8469dc166c27"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://ftp.osuosl.org/pub/midnightcommander/"
    regex(/href=.*?mc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "1cf10d6382ee603a2b15735029d31b7bea7bb65f29a50dbbc1c61a828d3cf433" => :big_sur
    sha256 "5abcb40119f47df346dd0b2c3a4c101422b594b3c0db2225ee38a3ebb2b7caa0" => :arm64_big_sur
    sha256 "2c36f252c47b8ecff2fa4afb4191a963af7c3d30a8aeb267a40f967873a01643" => :catalina
    sha256 "224d6aa6577e51952833ee65888bb99eacb89508dc9ac2f82a0e679b4635d7e3" => :mojave
    sha256 "79c2208b2097941cf3a792f47ad1f280ddbc3add7bd631084484163b7ba14ae9" => :high_sierra
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

  conflicts_with "minio-mc", because: "both install an `mc` binary"

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
