class Limine < Formula
  desc "Modern, secure, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://github.com/Limine-Bootloader/Limine/releases/download/v12.9.4/limine-12.9.4.tar.gz"
  sha256 "4f75ffca8e11a1030e43e2b9ab82fac1a0f8985e1c40d429fea9fd2972693447"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "819b2007a752db7de447b61aebeb8c5a52344665a4b7602659b3fd06a53cbe34"
    sha256 arm64_tahoe:       "a89bd5d437964399b10c018a41b605f9f23894b27fcc0abed1ffe15a0dcfc9d2"
    sha256 arm64_sequoia:     "aa3e1c1e9e26f4e7bbec3411f7ceef490467373ca91a7c7680e9738cd71a3c54"
    sha256 arm64_linux:       "f7301f778cffe7a356a81e679d5e2706befce1574af6d69a5f7c28d0397021f3"
    sha256 x86_64_linux:      "9a8d8df0abb857dc9ac212e926c48cc3ce10cf9ee2c70da5867664f7012503d7"
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
