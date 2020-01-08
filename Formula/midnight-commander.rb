class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.23.tar.xz"
  sha256 "dd7f7ce74183307b0df25b5c3e60ad3293fd3d3d27d2f37dd7a10efce13dff1c"
  head "https://github.com/MidnightCommander/mc.git"

  bottle do
    sha256 "5c97885f5afc7eeeb4cf0cafc805f551dcd05ef88d918b401619eda36f0e5d2b" => :catalina
    sha256 "e76360b03ae28f84ee962e1e15a7bd4506a7bb7dc0811f88647beed8a21beae4" => :mojave
    sha256 "cac5b58750645de5fb74112a5ba5e640593500fc3b78d45d33432d448e962d61" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libssh2"
  depends_on "openssl@1.1"
  depends_on "s-lang"

  conflicts_with "minio-mc", :because => "Both install a `mc` binary"

  # Fix compilation https://midnight-commander.org/ticket/4035
  # Remove in next release
  patch do
    url "https://midnight-commander.org/raw-attachment/ticket/4035/mc-4.8.23.patch"
    sha256 "eca0c095700bc4c4a41e74da0f95874c4a91a0f22ad45b2d96b32d2f537d856f"
  end

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
