class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://codeberg.org/Limine/Limine"
  url "https://codeberg.org/Limine/Limine/releases/download/v10.3.2/limine-10.3.2.tar.gz"
  sha256 "2de481b28fd8e88f25232dd32ef19e64b3e3c6c2f5787aff6122978251cad3cb"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "6a091e47ba8d5d84756cc6fdbb41aa60052a35ea14dd3d6e5c2f08cf4513b79b"
    sha256 arm64_sequoia: "7d6444633b4d730784f3e283f68a8a2e463d32b32a34f45628c20d93a9825dab"
    sha256 arm64_sonoma:  "7ea49a2616589c4154ea126581583ef7a2f1d3c5a9d65f2e4f76eaeaf22a6806"
    sha256 sonoma:        "5579b09e79a8a4595eb52870f446d233f3fbdea0578b02a5405e6fe726b00858"
    sha256 arm64_linux:   "12d446f70d055884dca20139b706c0f62e5f8a7ce3196f8a8efc788ba5d6c460"
    sha256 x86_64_linux:  "8a214aa6a4787ef8adfd95d40516ceae9ef7127a077a53612fd219d1cac19bea"
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
