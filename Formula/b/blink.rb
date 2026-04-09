class Blink < Formula
  desc "Tiniest x86-64-linux emulator"
  homepage "https://github.com/jart/blink"
  url "https://github.com/jart/blink/archive/refs/tags/1.1.0.tar.gz"
  sha256 "2649793e1ebf12027f5e240a773f452434cefd9494744a858cd8bff8792dba68"
  license "ISC"
  head "https://github.com/jart/blink.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe96f01e4cb3db83a0d8fe235ce54e5a00ff81d82da4872ac75772d93b49fe02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "728a23165b6adb6121ef66bf6b0ef9b9e68d863eb66b33bf40814d19bda11134"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ce2f125a8c3ce801bd477453488423c476a1768310bc6da2134a1e79f5edef6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbbe63a33126b154702707e358e10da2d4adaf9d9fe53db3cad1ed78f9223dac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53e2fc3a0987c15b8d8062fd564c33e2a2ed9718ae642480ccbad551b8076922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd87330b12e6d29f51065b58eeef882b7509537e145218f5d49b3102caf6e53e"
  end

  depends_on "pkgconf" => :build

  on_macos do
    depends_on "make" => :build # Needs Make 4.0+
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # newer linker cause issue as `pointer not aligned at _kWhence+0x4`
    # upstream bug report, https://github.com/jart/blink/issues/166
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    system "./configure", "--prefix=#{prefix}", "--enable-vfs"
    # Call `make` as `gmake` to use Homebrew `make`.
    system "gmake" # must be separate steps.
    system "gmake", "install"
  end

  test do
    stable.stage testpath
    ENV["BLINK_PREFIX"] = testpath
    goodhello = "third_party/cosmo/goodhello.elf"
    chmod "+x", goodhello
    system bin/"blink", "-m", goodhello
  end
end
