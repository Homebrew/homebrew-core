class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://codeberg.org/Limine/Limine"
  url "https://codeberg.org/Limine/Limine/releases/download/v10.7.0/limine-10.7.0.tar.gz"
  sha256 "d60c20cf221278e8f8404f2167f2830955bca82418be9404ea57ff3758edd09e"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "72530199d817824664279305bc3db300408fe177d1e0fe9871a3d2adaa52f0cb"
    sha256 arm64_sequoia: "c0a4a3a0359434c95f0e43ad8bb4542aaf0fb1e95e9f9c700dff1e0d359b2894"
    sha256 arm64_sonoma:  "2743971c5092dac703bb32781b54dff1ecc16293880ca873b1c732ab572b5554"
    sha256 sonoma:        "e31040d3c832871a0660293b4fbca7db715a8611b0c0becc6d5784cc4aa73d91"
    sha256 arm64_linux:   "b4dc2c651f4c78882b4c2b52dc2a68328c7cd428b3af95be4d75ad8d09536a7c"
    sha256 x86_64_linux:  "ea90e608dd3de7fa3d06e6af376da59cd70fce2fd9f44975206e2850bbaad50e"
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
