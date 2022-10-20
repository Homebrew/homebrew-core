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
    rebuild 2
    sha256 cellar: :any,                 arm64_monterey: "906faeef395d49a464d05b3dd09fc8cf45930812dc3ed406bc3ce2a30e4e81d5"
    sha256 cellar: :any,                 arm64_big_sur:  "1d6d5e1f9cabb92201022499fa94fc0fe154a5c88ef956d4e822073fd46cace8"
    sha256 cellar: :any,                 monterey:       "00a56f37ea35e7546d518a011131a5576dc45596eca0251781969400d7882ca3"
    sha256 cellar: :any,                 big_sur:        "59436ec2d4257478c10c3c8d811ff0116f599b83ea77d9a0f9c2a6e1efdcb3d2"
    sha256 cellar: :any,                 catalina:       "c6a9798845991625cede35b99fd1a21f0dc264e0b639b2fc7881d2559dfef615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8cd4e2d13c394406ad516d6a19d4613ef09b7f684ae43f44161e13f91740508"
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
