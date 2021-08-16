class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.27.tar.xz"
  mirror "https://ftp.osuosl.org/pub/midnightcommander/mc-4.8.27.tar.xz"
  sha256 "31be59225ffa9920816e9a8b3be0ab225a16d19e4faf46890f25bdffa02a4ff4"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://ftp.osuosl.org/pub/midnightcommander/"
    regex(/href=.*?mc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "e0dcbb747b0ed2e44c42ac024a42ac657da5b8d3898d1caa6d1bc029cbca13cb"
    sha256 big_sur:       "2035ff99bbb38fe1f12f4cf5c311b453c89d295a988ff570a5c4cab2834a4232"
    sha256 catalina:      "9de49345aabc060d430d444b0b94b7e00593253ac1f21a3718c483303621abdf"
    sha256 mojave:        "959dfb0d8538524172c68cb394046fb4c3be78803e8307a759bdc564ff86b783"
    sha256 x86_64_linux:  "e346f397da1f25b9eef69eb7e5011742d1cb59c091832f4080aec8ceee2fb485"
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

    on_macos do
      inreplace share/"mc/syntax/Syntax", HOMEBREW_SHIMS_PATH/"mac/super", "/usr/bin"
    end
  end

  test do
    assert_match "GNU Midnight Commander", shell_output("#{bin}/mc --version")
  end
end
