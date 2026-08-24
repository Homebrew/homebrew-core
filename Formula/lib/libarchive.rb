class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.8.9.tar.xz"
  sha256 "888c934f9d95648ecb9163dc8e23ab80a476ecb81a8f1154704a227b5b676dde"
  license "BSD-2-Clause"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0d24892c4031758a148bece7e41b82cc8be8c8af020eb379d43a98cf984ba26d"
    sha256 cellar: :any, arm64_sequoia: "0b478eea5f3310c1e3ec4a498e1d57417a59aaa5858e4a878dd0b78fd851aea6"
    sha256 cellar: :any, arm64_sonoma:  "4561e7a6d54788627a8e50f188a5f8bddcba31ad1676423b84a8723282e77d2e"
    sha256 cellar: :any, sonoma:        "17853cfab59f8768b8a68516e81ff41f0a5a23bbda3c51f8823e3664e608bd3f"
    sha256 cellar: :any, arm64_linux:   "e0f5f37cce9f478e4dcd21b0475bdff91dbf1b15a0ea2cce7df62c66fbeddc65"
    sha256 cellar: :any, x86_64_linux:  "c1c7ca1b5542a8cc1f375b1e0b150b547b9b3c09914481d6b0b2bca938ec273c"
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
