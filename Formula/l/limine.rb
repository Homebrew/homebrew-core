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
    sha256 arm64_golden_gate: "601b1047ee37e87325481b9566c7ca2d60d24d657b29f17a1d52879c3ffb1d16"
    sha256 arm64_tahoe:       "aa38a5fce5f65c1420007a34372bb0c879c9ef45d0f710b58fa9453e41a9b466"
    sha256 arm64_sequoia:     "a5593eb638a1832612939f56959a4b9644269fbdeec696fc6781d79d77e4ed99"
    sha256 arm64_linux:       "a3c63317c1dd6a1bf98219c99257d5d979b40f0feb33be28e99729d7447831eb"
    sha256 x86_64_linux:      "75956775a13e9f382abf489cbf798d677fda880bf8a8a3a69fedb550ced45f87"
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
