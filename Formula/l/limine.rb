class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://codeberg.org/Limine/Limine"
  url "https://codeberg.org/Limine/Limine/releases/download/v10.4.0/limine-10.4.0.tar.gz"
  sha256 "c823588c61b907e1bef2588955973e556d99a926ee702e7961f13142478cbfa4"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "abdfe94f639cd5f6420c3b876036f9278689da3818cd854b5561de993a3b812e"
    sha256 arm64_sequoia: "cfbc32cbcc111b03b297cee3a8b719c71dca9cd9074c5ffbe2db72bb93766e3e"
    sha256 arm64_sonoma:  "10404abd7224bf979c690fa2fa24794268037ce6defe20d285d55a53228f6a80"
    sha256 sonoma:        "af323c2896ef26e02f30c044b8432412b9b1e3709ef9bb2561163e184a764357"
    sha256 arm64_linux:   "6ece47e0024dc9fa7fe8cb01695689a4c03d53b1bab24a30818cf561e3bae7f4"
    sha256 x86_64_linux:  "e57bbd352fdbe81946c72a3b95ec8361b5604eab14013b4595d1d1168c5e1614"
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
