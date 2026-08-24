class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://github.com/Limine-Bootloader/Limine/releases/download/v12.6.0/limine-12.6.0.tar.gz"
  sha256 "3177b8a64297667a379feb3af6405b13c536409ce46d712ea1233e9ed1f87b9a"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "1455dae17a8dbac390c61a31cafeaaeef60ee71d09b79b02592a32f6f937d307"
    sha256 arm64_sequoia: "ffa9b051ff44a145582384b4cddb49f9fa0ac4ca562fd8952055a238400b1d5f"
    sha256 arm64_sonoma:  "e8a4781e1c02d04cf3ab798c316c80175a1d99b1521dc96dc97a8181cb75e9ec"
    sha256 sonoma:        "b557abc3f8ad0cc71cd071611cc251390990869305308c4ee838f3e7c2af323b"
    sha256 arm64_linux:   "58f070f0ec5d2f09f2f4d4ee8a88acd27824c9e24f5370112302b24e930cf64e"
    sha256 x86_64_linux:  "aeb8b767720cb24c5f2d9e8bf447185a9b6d39b6b025f8cd269d3d70e61a975a"
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

  on_macos do
    # Make < 3.82 picks matching implicit pattern rules in definition order instead of shortest-stem order
    # (https://lists.gnu.org/archive/html/info-gnu/2010-07/msg00023.html)
    #
    # Upstream is aware of this issue, try moving back to system `make` on next release.
    depends_on "make" => :build
  end

  def install
    # Homebrew LLVM is not in path by default. Get the path to it, and override the
    # build system's defaults for the target tools.
    llvm_bins = formula_opt_bin("llvm")

    ENV.prepend_path "PATH", Formula["make"].libexec/"gnubin" if OS.mac?

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
