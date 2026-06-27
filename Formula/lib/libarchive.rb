class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.8.8.tar.xz"
  sha256 "3873a88801da067d0528a989af06877710529d50ee8fe6f3970cbb4302efb918"
  license "BSD-2-Clause"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7b8bb55f7fbb3ec7a4edca069be2c0be136640a103f979b14cf440988becc911"
    sha256 cellar: :any, arm64_sequoia: "e7c8f89decda4e15a3a079940b3a4e1ce2d58864f4f7d9f1f940953371658d6d"
    sha256 cellar: :any, arm64_sonoma:  "244bbf2c50891f944cbe875797c0c0748893b2d637fc9e7b95c0e6912881c23a"
    sha256 cellar: :any, sonoma:        "30faf15b68a221a572a2d1c3d5377ee256d26b360ff2174f25de81dfcce4a4ce"
    sha256 cellar: :any, arm64_linux:   "8ecca8610f276ea18b09aa161c70a19c12aa02391b73a157769af2d6eb0707cf"
    sha256 cellar: :any, x86_64_linux:  "9002cf767c8289d63b24004d61cc59880d29b1115ed83b28ab3dd5cb7e124a63"
  end

  keg_only :provided_by_macos

  depends_on "libb2"
  depends_on "lz4"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "expat"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = [
      "--without-lzo2",    # Use lzop binary instead of lzo2 due to GPL
      "--without-nettle",  # xar hashing option but GPLv3
      "--without-xml2",    # xar hashing option but tricky dependencies
      "--without-openssl", # mtree hashing now possible without OpenSSL
      "--with-expat",      # best xar hashing option
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"

    # Avoid hardcoding Cellar paths in dependents.
    inreplace lib/"pkgconfig/libarchive.pc", prefix.to_s, opt_prefix.to_s

    return unless OS.mac?

    # Just as apple does it.
    ln_s bin/"bsdtar", bin/"tar"
    ln_s bin/"bsdcpio", bin/"cpio"
    ln_s man1/"bsdtar.1", man1/"tar.1"
    ln_s man1/"bsdcpio.1", man1/"cpio.1"
  end

  test do
    (testpath/"test").write("test")
    system bin/"bsdtar", "-czvf", "test.tar.gz", "test"
    assert_match "test", shell_output("#{bin}/bsdtar -xOzf test.tar.gz")
  end
end
