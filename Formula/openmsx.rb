class Openmsx < Formula
  desc "MSX emulator"
  homepage "https://openmsx.org/"
  url "https://github.com/openMSX/openMSX/releases/download/RELEASE_17_0/openmsx-17.0.tar.gz"
  sha256 "70ec6859522d8e3bbc97227abb98c87256ecda555b016d1da85cdd99072ce564"
  license "GPL-2.0"
  head "https://github.com/openMSX/openMSX.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/RELEASE[._-]v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "f2adab2e188fe3359050eac24577a703a3ca28be607033525b44cee9bc8f48bc"
    sha256 cellar: :any, arm64_big_sur:  "08121d09a6958b097d45b35f3db2b9cf172c3448ea3cfa1a42d9c5806ab55270"
    sha256 cellar: :any, monterey:       "4bb067ee6ba11fd48cbe4a97281835bd44df215d4e7b7473cadc6e0a698f4de2"
    sha256 cellar: :any, big_sur:        "0d2b0c7de2234c34935f11f952ea5ae8b4b818a4d87d83b5617bc28999956ab4"
    sha256 cellar: :any, catalina:       "39fc0cf97185508d3d107c73495f64cf6f44285f165b17852679e57caf8376b9"
  end

  depends_on "python@3.10" => :build
  depends_on "freetype"
  depends_on "glew"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "sdl2"
  depends_on "sdl2_ttf"
  depends_on "theora"

  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    # Hardcode prefix
    inreplace "build/custom.mk", "/opt/openMSX", prefix
    inreplace "build/probe.py", "/usr/local", HOMEBREW_PREFIX

    # Help finding Tcl (https://github.com/openMSX/openMSX/issues/1082)
    ENV["TCL_CONFIG"] = OS.mac? ? MacOS.sdk_path/"System/Library/Frameworks/Tcl.framework" : Formula["tcl-tk"].lib

    system "./configure"
    system "make"

    if OS.mac?
      prefix.install Dir["derived/**/openMSX.app"]
      bin.write_exec_script "#{prefix}/openMSX.app/Contents/MacOS/openmsx"
    else
      system "make", "install"
    end
  end

  test do
    system "#{bin}/openmsx", "-testconfig"
  end
end
