class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.28.tar.xz"
  mirror "https://ftp.osuosl.org/pub/midnightcommander/mc-4.8.28.tar.xz"
  sha256 "e994d9be9a7172e9ac4a4ad62107921f6aa312e668b056dfe5b8bcebbaf53803"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://ftp.osuosl.org/pub/midnightcommander/"
    regex(/href=.*?mc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "feee2456db02de756ee8d624dbf2170d67e61e9f2c57cc6fd2c7c19fc0ff2a41"
    sha256 arm64_big_sur:  "30d7ec30f929bab59cb60fa0265abf41f5afc696851be7c0c80ce0756cb05ccc"
    sha256 monterey:       "e421f892bd35e97be008972a38c3cf3e80f87009d8c9cbe03fc976b4e2792b95"
    sha256 big_sur:        "feaa7ababc4fa2b2ed201d222e4e6a24c055b3962f2661a9a930aa37922fec3b"
    sha256 catalina:       "51c915284413c26f18f27ed47a6bee028a6c0e8d9a4debd25ec4550f95e0fdf3"
    sha256 x86_64_linux:   "8b8d63b9bc38ad634047402e4cb57ee048c74f29e5dd4db95d75b0b2b45cd289"
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

    inreplace share/"mc/syntax/Syntax", Superenv.shims_path, "/usr/bin" if OS.mac?
  end

  test do
    assert_match "GNU Midnight Commander", shell_output("#{bin}/mc --version")
  end
end
