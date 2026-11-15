class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.8.11.tar.xz"
  sha256 "a3dc0872b1b39da34dc18ef1b944f0f11ffd37425d70ae04be679279f1cf43d2"
  license "BSD-2-Clause"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "80ad35d8783fa7650af7f21d58473d6a9eaa1b9939de5d2da2c916b9e9d92f30"
    sha256 cellar: :any, arm64_tahoe:       "ae94cc6cd4ecd7bed1cc80889b704806eba9d43c6e9afefc7f5ce7191f64ee92"
    sha256 cellar: :any, arm64_sequoia:     "93fd0ff4cb92c465817383520120baae8d404fb1c97e7bd1c48ed2d23687ab4e"
    sha256 cellar: :any, arm64_linux:       "fa164450c9f8f5d97e5293c232a91526a20f1cbc81d3851665ef1c8dbabf962e"
    sha256 cellar: :any, x86_64_linux:      "36c26b84101e382d1e7035423167ab1e4584b68085782a14c1d3c346bdbbb502"
  end

  keg_only :provided_by_macos

  depends_on "libb2"
  depends_on "lz4"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "expat"

  on_linux do
    depends_on "acl"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
