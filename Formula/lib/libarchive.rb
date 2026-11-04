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
    sha256 cellar: :any, arm64_golden_gate: "ff99dd8abf1c0dd5dda11165e8307eb3eadece22d4b8003562b5869f9a9fc4f0"
    sha256 cellar: :any, arm64_tahoe:       "f9daa6da55d53558557ea005b19786be9a2153cf4cad43f5d0439c9d35ab7144"
    sha256 cellar: :any, arm64_sequoia:     "503847a252e54cec2415ab329e3a9a7b5be9d5624823a0e28bfb2b42e129c5e7"
    sha256 cellar: :any, arm64_linux:       "a4eb0407bd3595748cdaf0e96fe92f4bfb2b377937811a1b1fa8fea667b9c373"
    sha256 cellar: :any, x86_64_linux:      "c43b97f198208e62d35b4e649e458cd38c1ec5741f0a1e536f374291e6071fd0"
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
