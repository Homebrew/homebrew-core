class Openmsx < Formula
  desc "MSX emulator"
  homepage "https://openmsx.org/"
  url "https://github.com/openMSX/openMSX/releases/download/RELEASE_0_14_0/openmsx-0.14.0.tar.gz"
  sha256 "eb9ae4c8420c30b69e9a05edfa8c606762b7a6bf3e55d36bfb457c2400f6a7b9"
  head "https://github.com/openMSX/openMSX.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "86804cbafdb16650a98598f20ff8093acf2a375a3be469504f912160301b4196" => :mojave
    sha256 "1fe237fb4200b9f0574de19da59434ba04df35320d3cae9f285a17d7c3f73222" => :high_sierra
    sha256 "14b2a737d35b8725ac2eff3e4ec02f1eef45542c7795e902d704cbdaf76c1857" => :sierra
    sha256 "0789729f06a73ae5acd2a04df373f839a2ac7d14e5679a380f7a485a777124ff" => :el_capitan
  end

  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "sdl"
  depends_on "sdl_ttf"

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
