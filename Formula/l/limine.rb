class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://github.com/Limine-Bootloader/Limine/releases/download/v12.5.2/limine-12.5.2.tar.gz"
  sha256 "1780781336d690c551fc5305604b4c3e3d7499f6cebc504bfa0cda3b712213c1"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "133a10ca9f177a98dee9d7c3760bf2ee0ded95de912f95e5e039e6edc88c94d5"
    sha256 arm64_sequoia: "83afc1d726bab6a4bb2e98dbd2a075b40b528e3e9bd4227193529f41804790b5"
    sha256 arm64_sonoma:  "c89280093a15f7fd55c17755af95185e49fb47e257afaf51698ba4a1ced9469f"
    sha256 sonoma:        "9c5e2973096c80d00a125572ba83c448c4c1949a90aaf2def8bb6e8bbfa9cd12"
    sha256 arm64_linux:   "d2daa9f8fc32ec9a47d7bb344e190928026b069ae4b498bd7f602d7ebe7e631f"
    sha256 x86_64_linux:  "c54d2bacb09a92cc95a3e436070a55158688ef210e7a3dab750341922b804d23"
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
    llvm_bins = formula_opt_bin("llvm")

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
