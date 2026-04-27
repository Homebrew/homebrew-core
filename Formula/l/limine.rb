class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://github.com/Limine-Bootloader/Limine/releases/download/v12.0.2/limine-12.0.2.tar.gz"
  sha256 "6c71c1a90ad02d8d09fbc4647d2f6ab324469387f0db5c6c6f49c1d875642b08"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "28e3bc4d166ce60e6a15248c76cf58d834aafde8ee4bc63d9d99d269dbb17c40"
    sha256 arm64_sequoia: "62bce4c899c223c3d35e6e47e8ffc13c50f835b5b16e55171490f173de5596e0"
    sha256 arm64_sonoma:  "18a7a14116dae335e31b494369ea970f0452ace950a3736777f8ebeec91c76fc"
    sha256 sonoma:        "53f6bff83eca3f51555f33adff78856457fc6c988ef90e39aef3f943fe636275"
    sha256 arm64_linux:   "73248124b0e0407cb4773d6181239942aaee100cc94dbd7c7c87325496c84ef8"
    sha256 x86_64_linux:  "5a153923888d98e63424b54dfaf6975456bf00e54270e48667d00d112287ad96"
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
