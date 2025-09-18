class Openmsx < Formula
  desc "MSX emulator"
  homepage "https://openmsx.org/"
  license "GPL-2.0-or-later"
  revision 1

  stable do
    url "https://github.com/openMSX/openMSX/releases/download/RELEASE_20_0/openmsx-20.0.tar.gz"
    sha256 "4c645e5a063e00919fa04720d39f62fb8dcb6321276637b16b5788dea5cd1ebf"
    depends_on "tcl-tk@8"
  end

  livecheck do
    url :stable
    regex(/RELEASE[._-]v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest do |json, regex|
      match = json["tag_name"]&.match(regex)
      next if match.blank?

      match[1].tr("_", ".")
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "a15148e1fd3c7ece9f97d6c2b5e30ec03e5ae5613b44955fee21f49e44797f74"
    sha256 cellar: :any, arm64_sequoia: "4b315226f72089a44114b59aac99c0ba287437dec71b40be00e1c6b8d02e4ed4"
    sha256 cellar: :any, arm64_sonoma:  "08a73c81781242564a33a8c2e9a7a857459338dc2d3ac663c3621e3d682c786d"
    sha256 cellar: :any, arm64_ventura: "09277a1aa755529546bd671baf93e8c5ccac515bc07224fa8cc1ed1721f3eced"
    sha256 cellar: :any, sonoma:        "496e6ecb68035df31905e59a8cb50eb98a5a391c64220dfc28ca07d2b1f4df61"
    sha256 cellar: :any, ventura:       "c267e3a327095b54adbefad82c7c3b67c93c9f1420abc8c9c63683a366715fb9"
    sha256               arm64_linux:   "9f95dd7fa08f9e37773dc870573b8950196de1f58a4c4dce24d9ea13ebf33eec"
    sha256               x86_64_linux:  "6b4a654d5f1954125ed32caa067d7b441c384143c8a130702c68a90fd8b58e46"
  end

  head do
    url "https://github.com/openMSX/openMSX.git", branch: "master"
    depends_on "tcl-tk"
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
    depends_on "llvm"

    fails_with :clang do
      cause "Requires C++20"
    end
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "mesa"
  end

  fails_with :gcc do
    version "7"
    cause "Requires C++20"
  end

  def install
    if OS.mac? && MacOS.version <= :ventura
      ENV.llvm_clang
      ENV.prepend "LDFLAGS", "-L#{Formula["llvm"].opt_lib}/unwind -lunwind"
      # When using Homebrew's superenv shims, we need to use HOMEBREW_LIBRARY_PATHS
      # rather than LDFLAGS for libc++ in order to correctly link to LLVM's libc++.
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib/"c++"
    end

    # Hardcode prefix
    inreplace "build/custom.mk", "/opt/openMSX", prefix
    inreplace "build/probe.py", "platform == 'darwin'", "platform == 'linux'" if OS.linux?
    inreplace "build/probe.py", "/usr/local", HOMEBREW_PREFIX

    # Help finding Tcl (https://github.com/openMSX/openMSX/issues/1082)
    ENV["TCL_CONFIG"] = Formula[build.head? ? "tcl-tk" : "tcl-tk@8"].opt_lib

    system "./configure"
    system "make", "CXX=#{ENV.cxx}", "LDFLAGS=#{ENV.ldflags}"

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
