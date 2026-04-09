class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.8.6.tar.xz"
  sha256 "8ac57c1f5e99550948d1fe755c806d26026e71827da228f36bef24527e372e6f"
  license "BSD-2-Clause"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8928abf6f08744b1e63ba64835fc48bd2077de1258bbc6b66ebdc8388bdf0f65"
    sha256 cellar: :any,                 arm64_sequoia: "28a7abe201188cad3f92e61c211323a47bc1cf0f47b863a6745fb60dfbeaf2b9"
    sha256 cellar: :any,                 arm64_sonoma:  "6f7f2f34f07ee0bac4c2108d8f37b9aa69ff847c3d8b7a4638e98510b39c8a87"
    sha256 cellar: :any,                 sonoma:        "4d795f0ee2fe6b7daf5306da687fbc9e7a8eef4036fe139a4a7379ed6529adcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e86739a2b5b4b76ad38f5c5b779fef50a0a60e53a76ebf2e2b70428af6ee815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d05b8ad5c9b587a6e3f0a702105c2132e7dd79a684f83c87a811afa3ebcc8971"
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
