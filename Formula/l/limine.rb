class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://github.com/Limine-Bootloader/Limine/releases/download/v12.2.0/limine-12.2.0.tar.gz"
  sha256 "db8a119878cfeead63c0a78236c577c40539c5759496950ea0ed32a6cf567865"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "90e53a840407530d79af7fb8f8df6c91497746b5fc546dbf5e6361367a3790e0"
    sha256 arm64_sequoia: "691dfd953c5e7520d41b74caf0a084a050ceb7464b490a8989312ba82b78a53d"
    sha256 arm64_sonoma:  "c054d248285f5a22acfbf9f6dc518fa43f77ffd0e4b5696cef5889de52dd4daa"
    sha256 sonoma:        "a8ee6b26888a535fe971b8e0a27d0c280700e8ccce4c0f8461d0f2619cb850f4"
    sha256 arm64_linux:   "f87eaaac723f655bad25bad4d418ecaf7d7e16c074c5cb21ca49b8f15ff8a2db"
    sha256 x86_64_linux:  "3e9c0b1719446294fc7efaa232fe7b113a10fedf6ae1815b13089ee045cab315"
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
