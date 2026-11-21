class Limine < Formula
  desc "Modern, secure, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://github.com/Limine-Bootloader/Limine/releases/download/v12.11.1/limine-12.11.1.tar.gz"
  sha256 "95b4b52fbafeebad14d5faf9e73bf974da58f68d41d1713bcc452712baddebbd"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "1d4a418fa3cc9659b8be7460fbbe21140f402f5377c92be70f2d748453348519"
    sha256 arm64_golden_gate: "143dd354297f97f004d8fea3920f561ef113f8b04f8f84ba1340ef5dd1303d8f"
    sha256 arm64_tahoe:       "2880c2c37071d67fddfe255717a55e3696f88a24102594078346eb1b649a8e69"
    sha256 arm64_sequoia:     "f821f21f18048925479db4fc89500da1ea4fc85f769e8e11a02d9760213b37ee"
    sha256 arm64_linux:       "7930637490e28f6cfabaeb046e28fbc0f38542ec32c74d632c440b61e7d95980"
    sha256 x86_64_linux:      "57039510e50b5f0dc94c59bda3a253897070f5fd1bf87d3f7868b6e2091df3f2"
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
