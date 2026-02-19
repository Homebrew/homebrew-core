class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.8.5.tar.xz"
  sha256 "d68068e74beee3a0ec0dd04aee9037d5757fcc651591a6dcf1b6d542fb15a703"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c9c26bdbfd989e14ed9645fafec72ccb5c845a443c9c73d57f47301f7a21bd46"
    sha256 cellar: :any,                 arm64_sequoia: "9845f54ebf8b829bfd12710755157065f94d5cdf2ffca43390e709925e40c582"
    sha256 cellar: :any,                 arm64_sonoma:  "b8e283c5e59aad4c2cbd7d46187c8229e3d5fa1d61b43096f1f5730c6b04127e"
    sha256 cellar: :any,                 sonoma:        "0f2e24f6e29c8ad74326778eea1070fe4c5a5c0c285117a3e8f6a4b5707e5d76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "533902d9205b221993cf665772eae44e2a33424d2f0a2ff13b17769fc922a202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61c83e124381f5e889f5a1ca8bbb6cf73fbfd82b81628f2bf8bd39849f7fadac"
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
