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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "89c7955a19d04416183cf4b4e6228524269998f4db8b487e1c65c0fe72688164"
    sha256 cellar: :any,                 arm64_sonoma:   "313d497452b11b20bfd53228bc5862f6df8134133ac441f680ff62b20404b6ee"
    sha256 cellar: :any,                 arm64_ventura:  "a5dd401bb3451678067ba95a1ad51fef42a0456cb2c7b6eb8828de8b2692f1f4"
    sha256 cellar: :any,                 arm64_monterey: "14de96e3de2aa91141c2c88574653e1b6de932c3a0f4769be4c54e2ed8b22b40"
    sha256 cellar: :any,                 sonoma:         "bdf18586866bc4a721c02f0c31caa500d2a62d9a4fa2d8e1a61f24324977891b"
    sha256 cellar: :any,                 ventura:        "58dcee68370adf283f6142d7da65aa0ba9b92ac7a3005a9699555db9c9baff7f"
    sha256 cellar: :any,                 monterey:       "442fbca86c364459de2ff027d8e05cddd8b9d38808bc3ad3e5cf8dc61f9e563e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "146e2d23818ca92cd18f65073fd5d4a5a5afd718a676dbe476494fb289a73da9"
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
    depends_on "mesa"
  end

  fails_with :clang do
    build 1300
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "7"
    cause "Requires C++20"
  end

  # https://github.com/openMSX/openMSX/pull/1542
  # remove in version > 19.1
  patch do
    url "https://github.com/openMSX/openMSX/commit/78939807459c8647174d86f0bcd77ed4310e187d.patch?full_index=1"
    sha256 "cf752e2d85a8907cc55e12f7fa9350ffad61325c2614e011face593e57a58299"
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
    system bin/"openmsx", "-testconfig"
  end
end
