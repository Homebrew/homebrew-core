class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://ftp.osuosl.org/pub/midnightcommander/mc-4.8.33.tar.xz"
  sha256 "cae149d42f844e5185d8c81d7db3913a8fa214c65f852200a9d896b468af164c"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://ftp.osuosl.org/pub/midnightcommander/"
    regex(/href=.*?mc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a19238337f7eef1da99d690ae9f440956117ec6daa1235e7e08a05f0e9827451"
    sha256 arm64_sequoia: "c6914462166922365c2a56c49d4fc8bb3eb051d3022e67072e7fac0832e8121d"
    sha256 arm64_sonoma:  "5b4c29d7bff65c72443cc3ae9e004d0af04c38392819c432f1bded428324b549"
    sha256 arm64_ventura: "471749bae6d5735af1b5a8922700e74ef4f4f256b2e8b60ce5786a7148f51a7d"
    sha256 sonoma:        "d6e4cf2c8b3f9f9bef3a7a0f3a066a378c1f4c1b4bd05c3b455f20b0bfc09792"
    sha256 ventura:       "bd3a2cca7f5e7a5a19ce29ef376fdb01a6802a76d07daae05bf9bf7527edf08a"
    sha256 arm64_linux:   "a5073a3422e3f6503eaaa200b14f719fe6ca10cf191f2c635d623ddca06cbd3f"
    sha256 x86_64_linux:  "512a595e57bbdea41c7b80ef305023874b21d7d77a8f63ce6218af3afa0863c4"
  end

  head do
    url "https://github.com/MidnightCommander/mc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

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
    system "./configure", *args, *std_configure_args
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
