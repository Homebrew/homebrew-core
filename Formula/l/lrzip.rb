class Lrzip < Formula
  desc "Compression program with a very high compression ratio"
  homepage "http://lrzip.kolivas.org"
  url "http://ck.kolivas.org/apps/lrzip/lrzip-0.641.tar.xz"
  sha256 "2c6389a513a05cba3bcc18ca10ca820d617518f5ac6171e960cda476b5553e7e"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "eb408946ef673448b1c1d6d14d2f86b5319aa28bb3f0fc22f068a491ccdf26f6"
    sha256 cellar: :any,                 arm64_sequoia: "12594f990be465df28cd2eda0b23e0daccbf9f1169cf72b0e4427b1e1015de1a"
    sha256 cellar: :any,                 arm64_sonoma:  "1c6abd74fb352de7f2fbb41a9335d5b8104124649e1116457a68db5eeecc9dc8"
    sha256 cellar: :any,                 sonoma:        "d5ff4085aae34410488f4a1de66a8725bfe4a402a29d567aa31fae7844f19e91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5b9e0d8a3a15533dfb3cd1486db03ae5288ba4d910651d79d3b9b0929c1d3ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a051eea9d0b7d80d0f6f42d8be47e98c88aa51edf17a3fad1d87e875ae4f3b6"
  end

  # Newer versions also don't build
  deprecate! date: "2026-01-05", because: "is not available via HTTPS"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "lz4"
  depends_on "lzo"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
