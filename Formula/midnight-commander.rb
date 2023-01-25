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
    sha256 arm64_ventura:  "5fcf1f477115ffa8327ba5e14477583d4479a52565be424fa084981f3d770fde"
    sha256 arm64_monterey: "f145ce312865997b23d6d9dd7d78c9bbb102ac213ba7d38b83591e5063547081"
    sha256 arm64_big_sur:  "c98bc8192dd871bb023533603731c3ac9f9cc3ed632a925ce0b096472e4996f1"
    sha256 ventura:        "cb0103acc5687375d70e87a2d084f3f3854b9870c387d324c0e5e7654cd28be3"
    sha256 monterey:       "9aff4b8cf1c36b1a1921adeb946e2a3a02f1cf401174ddaf8ac55bd5535db1fb"
    sha256 big_sur:        "823cd1f029759ccadf7ed61a298a4afad3140cbb05db9729b5f3de2dc0763dfd"
    sha256 x86_64_linux:   "228bcff199b009feb24475fef0f4c03b6e41e98534570544571bb55f5fb52d93"
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
