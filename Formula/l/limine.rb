class Limine < Formula
  desc "Modern, secure, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://github.com/Limine-Bootloader/Limine/releases/download/v12.9.0/limine-12.9.0.tar.gz"
  sha256 "adea922af3b9c8179a4676bcecc8e4df2f3ef72ad36b3f4afab44cbf5f265e36"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "765fe46762eb3e376e221a68c7fe17b7f5951e2490b50e3a481e3230c021bb64"
    sha256 arm64_tahoe:       "cc0a061981f1edb3fe6a1b1072c0fbd8467cc81d3ce53b8037442af0e4983b62"
    sha256 arm64_sequoia:     "ace7b05408a40874d668f9e00bbb582041d5294b67051515804244bf8aae3058"
    sha256 arm64_linux:       "db9a07197b6333b3692c9a1338b57213eeaeac224356d435437bf3201a5ce40a"
    sha256 x86_64_linux:      "29170d29dccf17875e2d664deabd5e0cbe84e6dab6c57408b409631798930df5"
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
    output = shell_output("#{bin}/limine bios-install #{testpath}/test.img 2>&1", 1)
    assert_match "error: Could not determine if the device has a valid partition table.", output
  end
end
