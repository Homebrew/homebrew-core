class Openmsx < Formula
  desc "MSX emulator"
  homepage "https://openmsx.org/"
  url "https://github.com/openMSX/openMSX/releases/download/RELEASE_19_0/openmsx-19.0.tar.gz"
  sha256 "bbc8afff5f933278ed96b1699446b7c85daeeaa1b71fd369391231d6474b3af1"
  license "GPL-2.0-or-later"
  head "https://github.com/openMSX/openMSX.git", branch: "master"

  livecheck do
    url :stable
    regex(/RELEASE[._-]v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9a26afc3143a8cbcd38bc1fab2aabf12087054a91d80bf042d2723b61742e44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "677d11ca125b73f9eb43730abe19f86462c0397c4a348461dc550700016b14ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13e6427001210187c09c65a17eb7abadb1481ec73387b6a3ae3ffcab0fcd6de5"
    sha256 cellar: :any_skip_relocation, ventura:        "dfc639b3b7fe4ef943ec4890add0bc5881d9f5573b6029ae45ac5d860ce24d40"
    sha256 cellar: :any_skip_relocation, monterey:       "af508931f94301164cef50c82f134d92b3ac6a697f4f575731fbd627ff1d8532"
    sha256 cellar: :any_skip_relocation, big_sur:        "319a5085d7ed0ddf6a08a39d5942837f423412a305dbb4cf5b11fdcd91a2d9ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec2ae1eaab1752ecb6309a49470417a87cb2f85eb9de3d57f9c33313f2bc9525"
  end

  depends_on "freetype"
  depends_on "glew"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "sdl2"
  depends_on "sdl2_ttf"
  depends_on "theora"

  uses_from_macos "python" => :build
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1300
  end

  on_linux do
    depends_on "alsa-lib"
  end

  fails_with :clang do
    build 1300
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "7"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1300

    # Hardcode prefix
    inreplace "build/custom.mk", "/opt/openMSX", prefix
    inreplace "build/probe.py", "platform == 'darwin'", "platform == 'linux'" if OS.linux?
    inreplace "build/probe.py", "/usr/local", HOMEBREW_PREFIX

    # Help finding Tcl (https://github.com/openMSX/openMSX/issues/1082)
    ENV["TCL_CONFIG"] = OS.mac? ? MacOS.sdk_path/"System/Library/Frameworks/Tcl.framework" : Formula["tcl-tk"].lib

    system "./configure"
    system "make", "CXX=#{ENV.cxx}"

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
