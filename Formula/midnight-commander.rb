class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.29.tar.xz"
  mirror "https://ftp.osuosl.org/pub/midnightcommander/mc-4.8.29.tar.xz"
  sha256 "01d8a3b94f58180cca5bf17257b5078d1fd6fd27a9b5c0e970ec767549540ad4"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://ftp.osuosl.org/pub/midnightcommander/"
    regex(/href=.*?mc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "abd054157405602e35a08c7bdcd678ef298cf33476ad099ca9ef3c7d50b7090d"
    sha256 arm64_monterey: "80adee8c4275ad0d78a9b78428a14bd7f420a6a2275b216598e00ee776cccd4e"
    sha256 arm64_big_sur:  "fc3e4af13d343ed85f9c299ad5da26966d7ab4d6e7d2d4bc62e3219a785671c3"
    sha256 ventura:        "5df32a68a42f7151cd86e57a8b655b5ce6ac22be8cd339dda85ec975c8eb90bd"
    sha256 monterey:       "fd50dbec2047e44060b8c0b9563ad8be71288f58e657bc42c3ba211a21f44e01"
    sha256 big_sur:        "d35fba9416fdcc566de28e58b8d10cc197609b3f4c9e3ffe239fba86e6277ff6"
    sha256 x86_64_linux:   "e22475a7648e1d7a545ff4a410d7a3abcaedd9b8e1e9307a0d1ec3b57e5fbd67"
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
