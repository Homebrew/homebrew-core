class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://limine-bootloader.org"
  url "https://codeberg.org/Limine/Limine/releases/download/v10.0.0/limine-10.0.0.tar.gz"
  sha256 "cbbd3d314855fd2c2886b2821d45b688b02543f4732f19f501e4d5568e0c7f87"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "98a5f109bc6b6c9f20d8b2ebc2e71438fce040a981dd133310cf7b57f9f61602"
    sha256 arm64_sequoia: "f6b2521f4e6db22a9bb4dd324d6061eb28b425557214db8b9a99671e92a9cca9"
    sha256 arm64_sonoma:  "e6a5fd992d0b19c775c7893a26d20d3edb16733f38fd13d085fea4219339d941"
    sha256 sonoma:        "5585bf0487a8015bf6296bb1ab148cd3de02fa66e5b2be2e9b04958d0f577636"
    sha256 arm64_linux:   "e8131da08fde8811e2a2e464e8b2737c509db9a2da886da78e7f51697b8d01ea"
    sha256 x86_64_linux:  "f04d449ec438ad9830f104874618a7ca3967174f2405660c5c70a86d80252499"
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
