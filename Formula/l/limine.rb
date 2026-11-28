class Limine < Formula
  desc "Modern, secure, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://github.com/Limine-Bootloader/Limine/releases/download/v12.11.2/limine-12.11.2.tar.gz"
  sha256 "985341dec2e51e91e5c0ea8717a705b51ed2a4f694091bbad4fb64731d522aaf"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "816bd4e0e56f35f91165382d788818ea002eb51366a15d75db8d3ffa2aa849b2"
    sha256 arm64_golden_gate: "2c3c2c039aa0f785e70b813f401c66294268367d846b4947adf54f59a7c68a66"
    sha256 arm64_tahoe:       "8edb6cb936a05a3bbfa0c2c5f70c34d57497c9bd21753ef02784298a05d40e50"
    sha256 arm64_sequoia:     "f2bffd49e1865eec723debda1c881c4ced26fed394c62d5334f8dd793be81d10"
    sha256 arm64_linux:       "5bbd9607857262f230840ed4bd82bbee914a9e5bc43513bf1d4d8bd4ff76e07f"
    sha256 x86_64_linux:      "2a77ebae897783a2198313bdf43bf3ebe93bcbb5b4105541e402f84bf308a48a"
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

  deny_network_access!

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
    output = shell_output("#{bin}/limine bios-install #{testpath}/test.img 2>&1", 1)
    assert_match "error: Could not determine if the device has a valid partition table.", output
  end
end
