class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://codeberg.org/Limine/Limine"
  url "https://codeberg.org/Limine/Limine/releases/download/v10.6.3/limine-10.6.3.tar.gz"
  sha256 "e23a71489f991d8b1a5fb79884ea278758ff61ef5017b5adf24493ec26c1b4a9"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ea4024d0ba8330d60110f984e611783e51952fc7f8c6e1d5bef69d7e0aed30fa"
    sha256 arm64_sequoia: "f49cb781f6a0eb1a742e7ff7262a6b31538f8c3099f721a861a521e9d19d6f02"
    sha256 arm64_sonoma:  "4f1970da7756c14ba3f6f0d846af47701279ac5ed2e9604c13646606c9cf1231"
    sha256 sonoma:        "e54626be014a45b23661f1ac4e2e25d23488ecbbbbeaa663bfbd1d6524e0183b"
    sha256 arm64_linux:   "10f391cc75c826c7374e643d087521b39f02f2d6e5caed7e2fa0db65e8e6ce92"
    sha256 x86_64_linux:  "978f0e973579f887e67892681b8ec48d7358bcfd32158bcea7af4fae56fa52e0"
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
