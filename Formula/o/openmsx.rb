class Openmsx < Formula
  desc "MSX emulator"
  homepage "https://openmsx.org/"
  url "https://github.com/openMSX/openMSX/releases/download/RELEASE_20_0/openmsx-20.0.tar.gz"
  sha256 "4c645e5a063e00919fa04720d39f62fb8dcb6321276637b16b5788dea5cd1ebf"
  license "GPL-2.0-or-later"
  head "https://github.com/openMSX/openMSX.git", branch: "master"

  livecheck do
    url :stable
    regex(/RELEASE[._-]v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest do |json, regex|
      match = json["tag_name"]&.match(regex)
      next if match.blank?

      match[1].tr("_", ".")
    end
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "ee0a9be62e2b1c04669a5fdbadbf59ece48fb64cfc5c6287cc3c404ce39f884f"
    sha256 cellar: :any, arm64_sonoma:  "ed81ae7655dd0ca38610c9c5fd48ede0676f2244e29cbdaef8e8dfd62f153abf"
    sha256 cellar: :any, arm64_ventura: "89b5d4a1cb8f3c248549e45542e47d15030eac7246d2f59162da2c9f4e162fcd"
    sha256 cellar: :any, sonoma:        "9362583e5d32849d94162a48cfc68d4294d01dd20d2fe968e54a2684590584cb"
    sha256 cellar: :any, ventura:       "66143d111af9938f34491c5e892c5884ddd501b5d10ca73fcd6665548f0fa7d5"
    sha256               arm64_linux:   "b28d983fd5fb53554e68e953bf0545ef30c7e5c3a61873f5bfc9b4d5591a7ab8"
    sha256               x86_64_linux:  "ab58976a39c13c22ef52e773f9faf6ea1f489e61164b4ff41d71e28376d4f30a"
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
  uses_from_macos "zlib"

  on_ventura :or_older do
    depends_on "llvm" => :build

    fails_with :clang do
      cause "Requires C++20"
    end
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "mesa"
    depends_on "tcl-tk@8"
  end

  fails_with :gcc do
    version "7"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.mac? && MacOS.version <= :ventura

    # Hardcode prefix
    inreplace "build/custom.mk", "/opt/openMSX", prefix
    inreplace "build/probe.py", "platform == 'darwin'", "platform == 'linux'" if OS.linux?
    inreplace "build/probe.py", "/usr/local", HOMEBREW_PREFIX

    # Help finding Tcl (https://github.com/openMSX/openMSX/issues/1082)
    ENV["TCL_CONFIG"] = OS.mac? ? MacOS.sdk_path/"System/Library/Frameworks/Tcl.framework" : Formula["tcl-tk@8"].lib

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
