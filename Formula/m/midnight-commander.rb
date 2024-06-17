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
    rebuild 1
    sha256 arm64_sonoma:   "db38bfda3b36eabaa861452b3edda1929d3bf09caf6e4703e1952a9e0fa550e5"
    sha256 arm64_ventura:  "1485984ff451a2e9cebca05381c076b19022add8e001017fe70a4cef38a2b583"
    sha256 arm64_monterey: "3c55ef249b10cd7a1406865e6c681b4f63fecc77c0c0bb5a1d6c87567e695319"
    sha256 sonoma:         "819441b71fb4b0fc93253a0a2347cf5c509d05bb0fb81ad931d6d16ec04452cb"
    sha256 ventura:        "619dec9f3c360453eece1a988827eb25d596f60bcd04c402d20639dd600519a2"
    sha256 monterey:       "4c37aa02e3733b307f0b6fae9142213cb1ef349bc9a4b84cf017468d6537f5be"
    sha256 x86_64_linux:   "ba4853c54f2abb917b60797f9008dd07ec9fdce81e2794aa121e94c6020eaf0b"
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

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"

    inreplace share/"mc/syntax/Syntax", Superenv.shims_path, "/usr/bin" if OS.mac?
  end

  test do
    assert_match "GNU Midnight Commander", shell_output("#{bin}/mc --version")
  end
end
