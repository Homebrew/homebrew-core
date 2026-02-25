class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://codeberg.org/Limine/Limine"
  url "https://codeberg.org/Limine/Limine/releases/download/v10.8.1/limine-10.8.1.tar.gz"
  sha256 "2b73da9688a7de6dcf514b58209565cb56946f1c7e6089b34d433c46980f3c69"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "acc88887d25e5c1563a3bddfa1ccbd9d78cb984b6c14edb79e706e64abe2fef2"
    sha256 arm64_sequoia: "deb8b76042ec4608a50503930394670eef628f1bbd16e77f83be9de758ae87e4"
    sha256 arm64_sonoma:  "3da547c9d6acfcdaa27cd4e61e737fe6ed66b1577b32472601ea65fd9f543319"
    sha256 sonoma:        "e8492686882f016e6b727ff8ea3a9d181f398e12e6cec1117816cc6392b6c16c"
    sha256 arm64_linux:   "6ec77a143fb6672629a972fbb1cb0bad889bd161bbb08b98fa0e8fa098d0e8a5"
    sha256 x86_64_linux:  "182de92065c825315cf05731cfc511326d7ba78e0cc77b496766703a19acf25c"
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
