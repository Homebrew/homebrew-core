class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://limine-bootloader.org"
  url "https://codeberg.org/Limine/Limine/releases/download/v10.0.1/limine-10.0.1.tar.gz"
  sha256 "ecff0dfc7a2695e4019e8697e92e55ecac17d46615218ed7914614f57a3d8e59"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0602d9600e386b6962e03ab74b03bfd7458655885325284df1da7c600c1afa8d"
    sha256 arm64_sequoia: "1a4bde484d3b4fc4f7aff02579de3a483ad9b5caf95097639197818c88d69b18"
    sha256 arm64_sonoma:  "a5c02fb54239d3a079429962ffdae0d91e653d6efb8291aefb1fc67495fb22f5"
    sha256 sonoma:        "bcaa672472d7e0da9c40f789220734c2c4aaa6c74d66b469b9ea56b965e2fe37"
    sha256 arm64_linux:   "ad82ee8fded7b180986a34f5569215e3dc24d1dbd794da0a42d971f902bfae69"
    sha256 x86_64_linux:  "b880e528c5e99a86f1dca881c57656840ac72b0807254db9f7c346ee1a4965fe"
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
