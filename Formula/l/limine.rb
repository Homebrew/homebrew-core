class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://codeberg.org/Limine/Limine"
  url "https://codeberg.org/Limine/Limine/releases/download/v10.3.0/limine-10.3.0.tar.gz"
  sha256 "d0b99b43e06ecdf3e7db105d70aa9c064c5b4759c9ad2c0892899aba99a22499"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d29a71819eb2fc97bcc33c01d2c2a7c7bb81608a664b5240fc91325a3c0a3b89"
    sha256 arm64_sequoia: "228646e6aba85255fda3bba2f5a297cdbc213ddf0e25842b08d23e9b5e8e94f0"
    sha256 arm64_sonoma:  "831646da17b473319cf95ee20f477ed1ef627473a7a32f9bcde98705ed9a20c1"
    sha256 sonoma:        "92de7e83f043f12cfdb34a7b080e9cf851653a495d5891a7198f9d5f42d6639f"
    sha256 arm64_linux:   "64730db3686202c9b7359eb787e940ad5415e277a695edbe72c51638310fa788"
    sha256 x86_64_linux:  "f81256253cdade720933771c8161abfc4933712e35f7ffd14b7811a04dead298"
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
