class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://github.com/Limine-Bootloader/Limine/releases/download/v12.4.1/limine-12.4.1.tar.gz"
  sha256 "2dca50927d564d80a246f2c49a4df58a2d4a37ada31c835bd28028885f6de55f"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b6cda57e989c57483122ed45cd7a5fb4f775cd11b03b59ce15d991473496ec04"
    sha256 arm64_sequoia: "4b081bedeeeb3337957da16c8e0c6acecae1545d525c3509eb11535817abfc0f"
    sha256 arm64_sonoma:  "89dd5ea4f92659093a220172df354e9fbef3056ed5f0f07d1db08a63a628c8d9"
    sha256 sonoma:        "c558597cf5b052b49e4a54367c4db3899921db6d3d8b0984f8372ab5a38c113d"
    sha256 arm64_linux:   "d46dbd246074e4291e86506982a0c75c9ffd29f0d7019e1eaf0d81d0e6189831"
    sha256 x86_64_linux:  "2d0e6fb809e597685cbc979159e228d272f6541b620506bda93cf9acbdca077a"
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
