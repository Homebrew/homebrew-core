class Blink < Formula
  desc "Tiniest x86-64-linux emulator"
  homepage "https://github.com/jart/blink"
  url "https://github.com/jart/blink/archive/refs/tags/1.1.0.tar.gz"
  sha256 "2649793e1ebf12027f5e240a773f452434cefd9494744a858cd8bff8792dba68"
  license "ISC"
  head "https://github.com/jart/blink.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f2fd0aa42196ee52060b934e6a3be257ad1326c062c8fa83bc6bf3888f38aec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcc500f8fe348d17be88e78813f689ad5f27a065db6112f5fa7e867e7c7f0139"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3682378ea5beb74906a12760147ddcae882095aa4a183f4fb328994ef9f8bb64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd18d0ceff9589f1ad6ea1dc5183c5c61f0234705d7789f6b26df8a47d830d94"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcca9fdf32d372f26ef410994a397e00d2c0ad337b32bfc397dffb5d8e9c831d"
    sha256 cellar: :any_skip_relocation, ventura:       "c6bf3d3adff77c984c9966cee9df01f2962fa1781d591dbe0de0a81666762812"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceddcd34e8f3929aacd7c139f86ca385e3a758417989d865b34a61437fbfc2ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae5240313e012eedfe56836839f4becd32fa8e3d22b690d1728aae141bb40025"
  end

  depends_on "make" => :build # Needs Make 4.0+
  depends_on "pkgconf" => :build
  uses_from_macos "zlib"

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
