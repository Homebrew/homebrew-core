class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://codeberg.org/Limine/Limine"
  url "https://codeberg.org/Limine/Limine/releases/download/v11.2.1/limine-11.2.1.tar.gz"
  sha256 "1d0ab886b8ee213418f626b5cf8a4a89df35f967d7f421945124147ef04f3e01"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "4f2ceb01f4391819b4eca337aa6fa9b074480a662c905b99a7bdd3ecd6f26bcd"
    sha256 arm64_sequoia: "0616b673da58732a00d5a48c327f5a31546e7f3f202b5bfc4cedf1338a40212f"
    sha256 arm64_sonoma:  "13eb2fe7fa4cac09cd10c69ac9510bad531884d462ae47b4b47aadfa038f9c19"
    sha256 sonoma:        "bc338d6e32eb7571638d61743f0c0d98f8b4e44583ae392e3a27813d33dce21d"
    sha256 arm64_linux:   "4a413e56e11f2f5d1ae8136d9c122005043fec6148e5c195c30568d627bdbf33"
    sha256 x86_64_linux:  "1a44caa6dc3af868dd8adf5d835d20d8edd03aac2df00f9b846555888bcf6d62"
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
