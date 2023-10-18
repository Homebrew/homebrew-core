class Openmsx < Formula
  desc "MSX emulator"
  homepage "https://openmsx.org/"
  url "https://github.com/openMSX/openMSX/releases/download/RELEASE_19_1/openmsx-19.1.tar.gz"
  sha256 "979b1322215095d82d5ea4a455c5e089fcbc4916c0725d6362a15b7022c0e249"
  license "GPL-2.0-or-later"
  head "https://github.com/openMSX/openMSX.git", branch: "master"

  livecheck do
    url :stable
    regex(/RELEASE[._-]v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fc603ee93d27464126277dc97a244707dbf534a2432781d6995bba3c4135a17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbeab633f428ffa82660c21e981473032adafd22697143db3c16c0679ae4cf4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b8801dbe18da6330df0aa221dda79f0d73e4290f79ee77267cdcaba3df83e0d"
    sha256 cellar: :any_skip_relocation, ventura:        "7114ed2d2d4ceb881ca64f0ed05d16d7d355aa1e5aaba54c6901a6f05cba2b16"
    sha256 cellar: :any_skip_relocation, monterey:       "149b0d1626cd2e2ae7782008f54118a13929245b79a7e74ed49d192e7aef77bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "faea2b8ed860e0ba7b62a6b74fad36916ed2dd2ec6d45dfdf4a30323aa3ce4c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd11f2af1e91fa6e4e59e952dead395775ff2858a6a65d954b696aa6539e10f5"
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
