class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://codeberg.org/Limine/Limine"
  url "https://codeberg.org/Limine/Limine/releases/download/v11.0.0/limine-11.0.0.tar.gz"
  sha256 "c10c77e5d255e465c5a8a7a8e8963329e0ac16500b5f93502456083085b7d862"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "64d61dabb9795d92cc11b42577300e83fff883531eaaeea26c3267c1806b441e"
    sha256 arm64_sequoia: "3d0337d78c41528999764a3968afe6b3c1a8302723aef9d70b29709fcb7b753f"
    sha256 arm64_sonoma:  "4d68add0da9b09ebc13851dd5b017eb2de14b5a87f78f41b47a5e8ebe1b8095f"
    sha256 sonoma:        "88f31046a81f2cdfd74f1ab86704581200c8f3251556e9b6351d797a71a7cd12"
    sha256 arm64_linux:   "86f425c8a85f68a31e473a35d9125dcf5b6da384d3d6e2239c6ee733a810fb27"
    sha256 x86_64_linux:  "c13a5d4bebcdeae0cea1043e6ffb27b4e5a37b04d6dbab4c549c6305fe1dcc67"
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
