class Openmsx < Formula
  desc "MSX emulator"
  homepage "https://openmsx.org/"
  url "https://github.com/openMSX/openMSX/releases/download/RELEASE_17_0/openmsx-17.0.tar.gz"
  sha256 "70ec6859522d8e3bbc97227abb98c87256ecda555b016d1da85cdd99072ce564"
  license "GPL-2.0"
  head "https://github.com/openMSX/openMSX.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/RELEASE[._-]v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any, big_sur:     "891284f2b5294dee367eb2db61f34f7940d2dd4ba26bcfa5e287a58b6419d019"
    sha256 cellar: :any, catalina:    "10c3e39c22efbd11e11b352f8fabfcea03633088cb16fe24611ed631325ed05c"
    sha256 cellar: :any, mojave:      "ed24d06d8f8913236fa619f0d92396e2a2a8d2f40afb5e56c609ecdf332b4ca4"
    sha256 cellar: :any, high_sierra: "86fff1a90fff96cb0398184ef7ebdeb804edda4c9d34ee5e7278159df64b10e3"
  end

  depends_on "python@3.9" => :build
  depends_on "freetype"
  depends_on "glew"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "sdl2"
  depends_on "sdl2_ttf"
  depends_on "theora"

  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    # Hardcode prefix
    inreplace "build/custom.mk", "/opt/openMSX", prefix
    inreplace "build/probe.py", "/usr/local", HOMEBREW_PREFIX

    # Help finding Tcl (https://github.com/openMSX/openMSX/issues/1082)
    on_macos do
      ENV["TCL_CONFIG"] = "#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
    end

    system "./configure"
    system "make"

    on_macos do
      prefix.install Dir["derived/**/openMSX.app"]
      bin.write_exec_script "#{prefix}/openMSX.app/Contents/MacOS/openmsx"
    end
    on_linux do
      system "make", "install"
    end
  end

  test do
    system "#{bin}/openmsx", "-testconfig"
  end
end
