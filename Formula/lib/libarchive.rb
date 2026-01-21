class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.8.5.tar.xz"
  sha256 "d68068e74beee3a0ec0dd04aee9037d5757fcc651591a6dcf1b6d542fb15a703"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "64462599d1d89aa6eb98797ca80c39bc491c1d3c7cafd4e1d76e8cca9d964100"
    sha256 cellar: :any,                 arm64_sequoia: "e66ef5adf6e4a18e85b539843551353b53fb0c4889bc47797d721e6b36be50dd"
    sha256 cellar: :any,                 arm64_sonoma:  "ad74cac45f900f21ca0a0449d5bcf2e8d5fe28ce7c11c126d386f372e2bb81d1"
    sha256 cellar: :any,                 sonoma:        "4ea4029b386797ed0db92d5036f6b7dff9b39db852fcd1d690a144d9fbb5eb22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9734647635e4b46166ed614de642a34838ce5d647e7a97bbc9345c3c972bac10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a5af0d3d3888ac0e912536969d456ab385c9fd914e6d56afda04db79ffddbd3"
  end

  keg_only :provided_by_macos

  depends_on "libb2"
  depends_on "lz4"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
           "--without-lzo2",    # Use lzop binary instead of lzo2 due to GPL
           "--without-nettle",  # xar hashing option but GPLv3
           "--without-xml2",    # xar hashing option but tricky dependencies
           "--without-openssl", # mtree hashing now possible without OpenSSL
           "--with-expat"       # best xar hashing option

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
