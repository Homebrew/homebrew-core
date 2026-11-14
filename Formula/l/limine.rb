class Limine < Formula
  desc "Modern, secure, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://github.com/Limine-Bootloader/Limine/releases/download/v12.10.0/limine-12.10.0.tar.gz"
  sha256 "89d043166c34dcf764171f2563a3820e836206f9696bfb01fee540efba4f6c81"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "002640c562c235fe57e65512e12b6eb4444144822b2a42bd52238bb63b3694d0"
    sha256 arm64_tahoe:       "d0d6099b7005149763523cb00e29746dfc9c897cc617dd57d51df0b58998f324"
    sha256 arm64_sequoia:     "dd11db136dd0c5639637bbf984dd53843c2c512d01326189df0526979908f491"
    sha256 arm64_linux:       "debb4cdd641babdab60b3cb51feee98944b32a26755d2681e8a35b18c2032cb0"
    sha256 x86_64_linux:      "1168cb4807d6216d6791e8688aa9bf0fb52a9d50fd7daa83c9db9483df985a72"
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

  deny_network_access!

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
    output = shell_output("#{bin}/limine bios-install #{testpath}/test.img 2>&1", 1)
    assert_match "error: Could not determine if the device has a valid partition table.", output
  end
end
