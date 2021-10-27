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
    sha256 arm64_monterey: "24f29d448f363b0c3cf793dbdf88fbf850b66a3fd550eb6dd01fd64f655f95e2"
    sha256 arm64_big_sur:  "3f45e1b92e6f263924e4544f0c935b4d18c1e37fdfcf0b7f7d5be369e05910b9"
    sha256 monterey:       "da16e0137f6702c18965c063cf6194e818dbb1a5e7f4db93ebc2d2606644469d"
    sha256 big_sur:        "31c1399b014432a36b0dcbb7b3834c50f7c5ac0809a8d1ae7bf8df8afbe838c1"
    sha256 catalina:       "1b39f54060789701af81163180ae7dab3fffcee18cc07bc6255f3f712504a3a3"
    sha256 mojave:         "dc2578f9825aa95824489fe52bfde70a130dadcd1c232c4fb07d538f1d9b19d1"
    sha256 x86_64_linux:   "2c3ec573057f385886b1c20515a8788e3c0b0d9767829dd3a93c74b5973a5cb3"
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
