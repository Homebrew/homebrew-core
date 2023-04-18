class Openmsx < Formula
  desc "MSX emulator"
  homepage "https://openmsx.org/"
  url "https://github.com/openMSX/openMSX/releases/download/RELEASE_18_0/openmsx-18.0.tar.gz"
  sha256 "23db7756e6c6b5cfd157bb4720a0d96aa2bb75e88d1fdf5a0f76210eef4aff60"
  license "GPL-2.0-or-later"
  head "https://github.com/openMSX/openMSX.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/RELEASE[._-]v?(\d+(?:[._]\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c88ed1921071cf39a547c1e89c96244daabffe03fcf23d447757c2ad80152073"
    sha256 cellar: :any,                 arm64_monterey: "85aead3586814f26eef0224afc1fd62cb3837909ae1b4af3e1380b1abe49661f"
    sha256 cellar: :any,                 arm64_big_sur:  "f99d60566159a10f90310769ece077eafeba03746d8c2a3b508287c251c4f223"
    sha256 cellar: :any,                 ventura:        "e8fe3426d99ecf8bc6e28539ae4dde0696c44afb172452c1fc50618df7a71e16"
    sha256 cellar: :any,                 monterey:       "4a0ea1fa214e29c33d3c94ee3a45922f565729a6eabb531971f72a02bfffea32"
    sha256 cellar: :any,                 big_sur:        "4fb17e2654f3eb4576f7953af9d721e21a5ccd0758b41554cdfe2a64983b5dfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98cf43540bc05224c493f35ded9a443003b279c65bfa5a351426dc98f9a12567"
  end

  depends_on "python@3.11" => :build
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
  end

  fails_with gcc: "5"

  def install
    # Hardcode prefix
    inreplace "build/custom.mk", "/opt/openMSX", prefix
    inreplace "build/probe.py", "platform == 'darwin'", "platform == 'linux'" if OS.linux?
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
