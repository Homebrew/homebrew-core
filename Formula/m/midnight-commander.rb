class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.31.tar.xz"
  mirror "https://ftp.osuosl.org/pub/midnightcommander/mc-4.8.31.tar.xz"
  sha256 "24191cf8667675b8e31fc4a9d18a0a65bdc0598c2c5c4ea092494cd13ab4ab1a"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://ftp.osuosl.org/pub/midnightcommander/"
    regex(/href=.*?mc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "a4c54152c514b16f70f8e58ba842d89a6e07c6a2b6f14083a851fac291dc4c6d"
    sha256 arm64_ventura:  "90131c6ef144b944c2d09ad8c59b4f4e4f249746669888404b8f8d50ed837181"
    sha256 arm64_monterey: "1b306039471c2b6c8bb20ac30138baaaedc4315497fdf3945d61fcbbbe98dd0d"
    sha256 sonoma:         "116dbf378bfbeb72b75a850be84f93f190f6f249477cea7c8f6bf54343d03d7b"
    sha256 ventura:        "2ad785a7f7277a49c18c4f45cf0b48572998c7d97db71e0d4e628737c5f3fb9a"
    sha256 monterey:       "5b7d18b46b938edb816c7560df7c4b356e8ab01558472d4f12f0e11c836e16e5"
    sha256 x86_64_linux:   "7a72a393d6610429cb35fd17266c06df529e049c7548481f0e68db85c55e492e"
  end

  head do
    url "https://github.com/MidnightCommander/mc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libssh2"
  depends_on "openssl@3"
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
    ENV["ac_cv_func_utimensat"] = "no" if OS.mac? && MacOS.version >= :high_sierra
    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"

    inreplace share/"mc/syntax/Syntax", Superenv.shims_path, "/usr/bin" if OS.mac?
  end

  test do
    assert_match "GNU Midnight Commander", shell_output("#{bin}/mc --version")
  end
end
