class Openmsx < Formula
  desc "MSX emulator"
  homepage "https://openmsx.org/"
  url "https://github.com/openMSX/openMSX/releases/download/RELEASE_0_14_0/openmsx-0.14.0.tar.gz"
  sha256 "eb9ae4c8420c30b69e9a05edfa8c606762b7a6bf3e55d36bfb457c2400f6a7b9"
  head "https://github.com/openMSX/openMSX.git"

  bottle do
    cellar :any
    sha256 "beb72a7af18689727fd44a726bc8cbc6ca021ce1b844960d537588a65e818407" => :sierra
    sha256 "f8aedb3421144750a2a0e81f1a417b74313611d5b5dd142fbc859518ca7cef51" => :el_capitan
    sha256 "6a650da914f1fa3034f85c7e804856b39d40a7b2aa7d02ec412579e5a8a4b30e" => :yosemite
  end

  deprecated_option "without-opengl" => "without-glew"

  option "without-glew", "Disable OpenGL post-processing renderer"
  option "with-laserdisc", "Enable Laserdisc support"

  depends_on "sdl"
  depends_on "sdl_ttf"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "glew" => :recommended

  if build.with? "laserdisc"
    depends_on "libogg"
    depends_on "libvorbis"
    depends_on "theora"
  end

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
