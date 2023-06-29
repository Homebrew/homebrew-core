class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.29.tar.xz"
  mirror "https://ftp.osuosl.org/pub/midnightcommander/mc-4.8.29.tar.xz"
  sha256 "01d8a3b94f58180cca5bf17257b5078d1fd6fd27a9b5c0e970ec767549540ad4"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url "https://ftp.osuosl.org/pub/midnightcommander/"
    regex(/href=.*?mc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "84c4c8b9f0f1d7ac87e4f72edaf82a98208043bd82fab1dff79bdd4f3c8170de"
    sha256 arm64_monterey: "570da292695980caeabf0c8728bca6b5eab9a11abcd19370700f024221a743cf"
    sha256 arm64_big_sur:  "e9d0b1f60c480e3351fc94002f3d5743b57d8d3098d2f84a527392618bb4ede6"
    sha256 ventura:        "c8ce411cb9c92f791b2e2b516e782369196ecc75541991ca6a4c8dc66d485cdd"
    sha256 monterey:       "615f4220d50caef801d175e06e0fc4e3e1db459217e76c97b8d685e0447a4321"
    sha256 big_sur:        "840c554ece6e30ea97d153a27df21bd207b534ec3893eda7fc4711e200c0ae6d"
    sha256 x86_64_linux:   "9c43af90de0768cb38771de82d38e88ab2aac764b57bf440dc33bb7c5e82835d"
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
