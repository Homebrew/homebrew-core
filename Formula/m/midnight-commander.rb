class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.32.tar.xz"
  mirror "https://ftp.osuosl.org/pub/midnightcommander/mc-4.8.32.tar.xz"
  sha256 "4ddc83d1ede9af2363b3eab987f54b87cf6619324110ce2d3a0e70944d1359fe"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://ftp.osuosl.org/pub/midnightcommander/"
    regex(/href=.*?mc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "d4a361245ce1023f004e6e8204b11ba919e59b297898e7a66cc96b81ef58a44a"
    sha256 arm64_sonoma:   "4d8ff2cfd4c5016efb2b731d4266a83900cfd164edb522acb54d2b4d3f732274"
    sha256 arm64_ventura:  "233f9256cac1000fe98e86173cf2abb1e4555759a888261f76d4e1a3786fd699"
    sha256 arm64_monterey: "71b2eb7e58eda80f71b0be79e403cc23221ca879611bfa1d42c5fbd8e305c4b2"
    sha256 sonoma:         "7402ed037582a4c6571c058b2a447abbc7ce7b8b97a4728a7a0d70aedccf385c"
    sha256 ventura:        "fa3d7102a91c5febc694952d63d1bab5f113fcc79db982a8b7983cabed7f0716"
    sha256 monterey:       "f7915e04544fe79dd00fe848f603cc500292879d54135c8d2820db50bc36f309"
    sha256 x86_64_linux:   "10d00a3f8507c74d6128eeb7f93ab82b89cae4f396f7eb0b94516983e11d4fa7"
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
