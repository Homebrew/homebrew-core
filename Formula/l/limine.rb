class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://codeberg.org/Limine/Limine"
  url "https://codeberg.org/Limine/Limine/releases/download/v10.8.5/limine-10.8.5.tar.gz"
  sha256 "fb9eb2734258a6afd35f129dac29c04879b96d2930af940f4960be20b3033ece"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "35a3a6049c30a5166b065ee3c9f1a67bb3c7c513d892c05a6d2609ddcf7a6f79"
    sha256 arm64_sequoia: "f6df878f8af66172f376f32daf4d311e2170d4c39caee008af990e1be7ac074a"
    sha256 arm64_sonoma:  "347fdb275fc6f3c22ce4645c86b4d56269b8d6cceceaf6dbacc6790787a8663b"
    sha256 sonoma:        "e93944ba89805dec3cdd89517db6406f88ce20c660e925bb64b255356609ff10"
    sha256 arm64_linux:   "2fb627e304e0671263974093690c2e906daa1d23edc429aad25da5c3f4395db1"
    sha256 x86_64_linux:  "a54276a70dd2f99fd63cbeae466b25f85463b86282d59fab880778a537d2bd64"
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
