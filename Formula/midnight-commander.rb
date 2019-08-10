class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.23.tar.xz"
  sha256 "dd7f7ce74183307b0df25b5c3e60ad3293fd3d3d27d2f37dd7a10efce13dff1c"
  head "https://github.com/MidnightCommander/mc.git"

  bottle do
    sha256 "a09791d4752c87a4f02c9d45d418f282ebeab30089641ef0d0ec6d7390449815" => :catalina
    sha256 "f0a68c97b763f0287815a5aa09d001cf813595e3a9d4ba5ae5c25095adb666ce" => :mojave
    sha256 "a0c72e44f505ccb864b2b301a05cdec10580a26b195f574a46f0e552cf97e993" => :high_sierra
    sha256 "1d7f48e1c2834f4bb2a3dadc0df433eec646fe31bf1817e44fa9a16dc91ee941" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libssh2"
  depends_on "openssl@1.1"
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
