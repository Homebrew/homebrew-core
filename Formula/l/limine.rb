class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://github.com/Limine-Bootloader/Limine/releases/download/v12.3.2/limine-12.3.2.tar.gz"
  sha256 "c505283106eaddfa5bbc56d8c1b1cf333d12654dcb37f80e685d3576e8702865"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d12aca20e67453105ae315b53cecc2118de0c10efc71c74ced765172acdec1ce"
    sha256 arm64_sequoia: "15536ca937ae2240d643c3f9b98497d7dd49fc9d87146f2956ce70e35ed61d06"
    sha256 arm64_sonoma:  "a9aed23ac45dc19cb3c078ad9b2ccee09935924037ffbe8600123a3a107bcb39"
    sha256 sonoma:        "f2621bf6bbba41c3790f7a31483d9cbab6edab5b502a902ebeefda6f6527fb7c"
    sha256 arm64_linux:   "1b8e95872d3623f3cc9d65263171ff1c1617408bd9adb9c5c3cb11938d291d18"
    sha256 x86_64_linux:  "4226d8cf28edd699ae2f255e4077ab5367f69a05df1d173bde21f59c454a95ad"
  end

  # The reason to have LLVM and LLD as dependencies here is because building the
  # bootloader is essentially decoupled from building any other normal host program;
  # the compiler, LLVM tools, and linker are used similarly as any other generator
  # creating any other non-program/library data file would be.
  # Adding LLVM and LLD ensures they are present and that they are at their most
  # updated version (unlike the host macOS LLVM which usually is not).
  depends_on "lld" => :build
  depends_on "llvm" => :build
  depends_on "mtools" => :build
  depends_on "nasm" => :build

  def install
    # Homebrew LLVM is not in path by default. Get the path to it, and override the
    # build system's defaults for the target tools.
    llvm_bins = Formula["llvm"].opt_bin

    system "./configure", *std_configure_args, "--enable-all",
           "TOOLCHAIN_FOR_TARGET=#{llvm_bins}/llvm-",
           "CC_FOR_TARGET=#{llvm_bins}/clang",
           "LD_FOR_TARGET=ld.lld"
    system "make"
    system "make", "install"
  end

  test do
    bytes = 8 * 1024 * 1024 # 8M in bytes
    (testpath/"test.img").write("\0" * bytes)
    output = shell_output("#{bin}/limine bios-install #{testpath}/test.img 2>&1")
    assert_match "installed successfully", output
  end
end
