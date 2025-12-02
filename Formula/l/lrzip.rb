class Lrzip < Formula
  desc "Compression program with a very high compression ratio"
  homepage "http://lrzip.kolivas.org"
  url "http://ck.kolivas.org/apps/lrzip/lrzip-0.641.tar.xz"
  sha256 "2c6389a513a05cba3bcc18ca10ca820d617518f5ac6171e960cda476b5553e7e"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://ck.kolivas.org/apps/lrzip/"
    regex(/href=.*?lrzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "7ba040424b61861e2e583c5797cde65885622182d4a99a20a38be74e0c4b86b9"
    sha256 cellar: :any,                 arm64_sequoia:  "34d8b5415f33f6227a73dbc8ab1957c2b1e3591e1c3ee5b8d01ca6123b9d9525"
    sha256 cellar: :any,                 arm64_sonoma:   "06cde83e30ff4c3ceb76cf9c855fe24540429fb009ab3b4d9cf92a470138240d"
    sha256 cellar: :any,                 arm64_ventura:  "ad6e28ccfb37ce81646fb1b40b000e7172906ff50da4e9804c8d41f3562e0e63"
    sha256 cellar: :any,                 arm64_monterey: "187914857fc2edba04f069d8fbd4d69bb8d140a9194b77b5bf45dd0295682c96"
    sha256 cellar: :any,                 arm64_big_sur:  "d9e67f4c880ecfe1e59f0714073f1dab6ce921a0585e763ab009bac21d545335"
    sha256 cellar: :any,                 sonoma:         "9c25ec5991ba62aa0f522b11b3c9197f323362326eea09f1a5d30c0bde48e234"
    sha256 cellar: :any,                 ventura:        "f9b6f58f250151a2c6b859e0c7ce5fc55ba1e721a1bebb879ce7f16f3eb60337"
    sha256 cellar: :any,                 monterey:       "d270d7085f30f8d07e32f746e8e9a10a09729ef6e60d0fbad9a5af85b1193522"
    sha256 cellar: :any,                 big_sur:        "33d561fad2bba643625d358fc65cfa2d8f37ae51d3329887da76e884d43b1515"
    sha256 cellar: :any,                 catalina:       "701705808812d442dbd211235510a039a53cd4de9a4b28c014da5ad8a000014d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3f8dfe3dd08b7231d134922f66dca8c88575590259bc3646d6582f2b4c6fb011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5515b974789a0665b67ceb99c09d7c2b4edae560c5d7e4d7aee765fe95a563e0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "lz4"
  depends_on "lzo"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_intel do
    depends_on "nasm" => :build
  end

  conflicts_with "lrzsz", because: "both install `lrz` binaries"

  def install
    # Attempting to build the ASM/x86 folder as a compilation unit fails (even on Intel). Removing this compilation
    # unit doesn't disable ASM usage though, since ASM is still included in the C build process.
    # See https://github.com/ckolivas/lrzip/issues/193
    inreplace "lzma/Makefile.am", "SUBDIRS = C ASM/x86", "SUBDIRS = C"

    # Set nasm format correctly on macOS. See https://github.com/ckolivas/lrzip/pull/211
    inreplace "configure.ac", "-f elf64", "-f macho64" if OS.mac?

    system "autoreconf", "--force", "--install", "--verbose"

    args = []
    args << "--disable-asm" unless Hardware::CPU.intel?

    system "./configure", *args, *std_configure_args
    system "make", "SHELL=bash"
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.lrz
    system bin/"lrzip", "-o", "#{path}.lrz", path
    path.unlink

    # decompress: data.txt.lrz -> data.txt
    system bin/"lrzip", "-d", "#{path}.lrz"
    assert_equal original_contents, path.read
  end
end
