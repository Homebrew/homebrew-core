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
    rebuild 2
    sha256 arm64_sonoma:   "f0705dc478f5ee10d280de6b2d02b8dc6bf03e7e24857d461a878a74ae5d437e"
    sha256 arm64_ventura:  "a370b58b90278689d30d71f15c120c9c6321d38ea94056c3b7fad38673ec8dd0"
    sha256 arm64_monterey: "afbb203e238eb94049ed948fe4ecbfe0fd8faef2230f735e54c502c6c5d33eea"
    sha256 sonoma:         "7ccb5bb2350689ba47c110d45b1cff222b8326f1fce7ecfec33e9914b2ef781e"
    sha256 ventura:        "1a79c8c1f27b44573196c0be681ef7f1b55484c31b08216b1504daf815847c0d"
    sha256 monterey:       "04a3ae62c176b08cb9e54d113bff88e8a7dbf855312c0a1a8b72c8e933f9f27c"
    sha256 x86_64_linux:   "6195bb65394f9b17c85c9469764635054ff2daa9c3d2f68d68471790a1c6f119"
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

  on_macos do
    depends_on "diffutils"
    depends_on "gettext"
  end

  conflicts_with "minio-mc", because: "both install an `mc` binary"

  def install
    args = %w[
      --disable-silent-rules
      --without-x
      --with-screen=slang
      --enable-vfs-sftp
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args, *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"

    if OS.mac?
      inreplace share/"mc/syntax/Syntax", Superenv.shims_path, "/usr/bin"
      bin.env_script_all_files(libexec/"bin", PATH: "#{Formula["diffutils"].opt_bin}:$PATH")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mc --version")
  end
end
