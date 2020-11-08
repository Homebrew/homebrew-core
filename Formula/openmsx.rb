class Openmsx < Formula
  desc "MSX emulator"
  homepage "https://openmsx.org/"
  url "https://github.com/openMSX/openMSX/releases/download/RELEASE_16_0/openmsx-16.0.tar.gz"
  sha256 "055c6d12c8c15eb49be1ce53587f560e53fa05bdb05a56a7a249489fe93fb04e"
  license "GPL-2.0"
  head "https://github.com/openMSX/openMSX.git"

  livecheck do
    url "https://github.com/openMSX/openMSX/releases/latest"
    regex(%r{href=.*?/tag/RELEASE[._-]v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "891284f2b5294dee367eb2db61f34f7940d2dd4ba26bcfa5e287a58b6419d019" => :big_sur
    sha256 "10c3e39c22efbd11e11b352f8fabfcea03633088cb16fe24611ed631325ed05c" => :catalina
    sha256 "ed24d06d8f8913236fa619f0d92396e2a2a8d2f40afb5e56c609ecdf332b4ca4" => :mojave
    sha256 "86fff1a90fff96cb0398184ef7ebdeb804edda4c9d34ee5e7278159df64b10e3" => :high_sierra
  end

  depends_on "alsa-lib"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "python@3.9"
  depends_on "sdl2"
  depends_on "sdl2_ttf"
  depends_on "theora"

  uses_from_macos "zlib"

  def install
    # Fixes a clang crash; this is an LLVM/Apple bug, not an openmsx bug
    # https://github.com/Homebrew/homebrew-core/pull/9753
    # Filed with Apple: rdar://30475877
    ENV.O0

    # Hardcode prefix
    inreplace "build/custom.mk", "/opt/openMSX", prefix

    # Help finding Tcl (https://github.com/openMSX/openMSX/issues/1082)
    inreplace "build/libraries.py" do |s|
      s.gsub! /\((distroRoot), \)/, "(\\1, '/usr', '#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework')"
      s.gsub! "lib/tcl", "."
    end

    system "./configure"
    system "make"
    prefix.install Dir["derived/**/openMSX.app"]
    bin.write_exec_script "#{prefix}/openMSX.app/Contents/MacOS/openmsx"
  end

  test do
    system "#{bin}/openmsx", "-testconfig"
  end
end
