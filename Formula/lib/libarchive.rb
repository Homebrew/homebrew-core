class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.8.10.tar.xz"
  sha256 "56cad765459d5ee25a3b761f90c47d99379d28297fbfb72d908880d6b875fb96"
  license "BSD-2-Clause"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f3af08b47c55d5b0b5730240978c899590b9cb66ddc77341b15a1c4bbe73d76d"
    sha256 cellar: :any, arm64_tahoe:       "18b30e3f5753983dc16c61cc3bb127ce02818085b8c6483f3d720dbfe78d5aaf"
    sha256 cellar: :any, arm64_sequoia:     "171706f55d0de1d512524bf20a62b1053b42603436a86fe4631043b7ac7be842"
    sha256 cellar: :any, arm64_linux:       "3e326062ac2d7d1a6033b22c6892cd7fec33287ffd3da77c73e7380844621d39"
    sha256 cellar: :any, x86_64_linux:      "bf0fc9aae7fa43927149765d4903eb38e91c59d35006d854480732c10dc9f61c"
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
