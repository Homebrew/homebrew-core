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
    sha256 "2035ff99bbb38fe1f12f4cf5c311b453c89d295a988ff570a5c4cab2834a4232" => :big_sur
    sha256 "e0dcbb747b0ed2e44c42ac024a42ac657da5b8d3898d1caa6d1bc029cbca13cb" => :arm64_big_sur
    sha256 "9de49345aabc060d430d444b0b94b7e00593253ac1f21a3718c483303621abdf" => :catalina
    sha256 "959dfb0d8538524172c68cb394046fb4c3be78803e8307a759bdc564ff86b783" => :mojave
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
