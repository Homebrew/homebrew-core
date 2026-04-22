class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://github.com/Limine-Bootloader/Limine/releases/download/v11.4.1/limine-11.4.1.tar.gz"
  sha256 "b139a355584e6f610e868856fd230982b33c1d3e6de9a7ead5e92ffba79936e6"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "fd6e47986b418f1f63c59accebc7356e725bf17bf906323d739addbe4ebb4985"
    sha256 arm64_sequoia: "3744f5f24b2bea49c7d63d190a68dded244fafb37759ab4c0d1ed0564744a12a"
    sha256 arm64_sonoma:  "b30fa5c70240f3bd50bc14bf8805aae5c76adb910ca9a21eaf0bd787b7c61355"
    sha256 sonoma:        "fc8d116b5abcc35f4f8c715b516a6d2be5b5fb5ccbdd2d1d8a2b2d12f4fa1d97"
    sha256 arm64_linux:   "8fd946078cee68ecb6417459c08a06677289a847e735e668e4ead56aebadc65b"
    sha256 x86_64_linux:  "e910dcf60b046a88f2cd6f805d9664a9f31b9f23c178971724bd841de562398f"
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
