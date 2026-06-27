class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://github.com/Limine-Bootloader/Limine/releases/download/v12.3.3/limine-12.3.3.tar.gz"
  sha256 "f1a529da5cd50a5ca37ba5873133a7b8e72584b127d7331fe94e554e5e6012f7"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "806415bfd26dd793a172e9f6ba2f015f707364b265f4cf83b33f46a53bc49769"
    sha256 arm64_sequoia: "03d6617b4e6a388ddc3413098b403a7beed91901ac4e1d68278eca307dc9fc64"
    sha256 arm64_sonoma:  "77aa10be24c0a332f5fc68913e9ad5f0ed0c1d1e7b0e209e143c55ac496d1576"
    sha256 sonoma:        "0ee9f7ecaf5d8345096127341ec922d9c5efa08ec41f08b4c9a7b634a7d4907b"
    sha256 arm64_linux:   "28b7a816a143492e67fd84d594cfd1463038a289ed8b0d00b3c176f71aefadf4"
    sha256 x86_64_linux:  "be7a1aa14859504bf922dc7e9640d916f117b8f0e635b85a11fda21a219e6ae8"
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
    output = shell_output("#{bin}/limine bios-install #{testpath}/test.img 2>&1")
    assert_match "installed successfully", output
  end
end
