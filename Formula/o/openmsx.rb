class Openmsx < Formula
  desc "MSX emulator"
  homepage "https://openmsx.org/"
  url "https://github.com/openMSX/openMSX/releases/download/RELEASE_21_0/openmsx-21.0.tar.gz"
  sha256 "28838bfa974a0b769b04a8820ad7953a7ad0835eb5d1764db173deac75984b6f"
  license "GPL-2.0-or-later"
  revision 1
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

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6244caea502ad4a17f1f84371f7c4bdf62c412c8743618a18017a1b0f56b9143"
    sha256 cellar: :any,                 arm64_sequoia: "2304ecae91e34e36305ea2a8fc98e42fe2c4e9c42f7bd274acf5602253d1e1f0"
    sha256 cellar: :any,                 arm64_sonoma:  "890c123b5456354ea46ccb1352972f1d3ac632fe1e5c2e9f9c9c9652ab9345f7"
    sha256 cellar: :any,                 sonoma:        "9960a99ce629978b0a64a7c5aaeee1d939474904793f166cddcbb7138ab376e6"
    sha256                               arm64_linux:   "fa49c48000867d2b69dfef7727f2ca857b86535dbd71c78aba8ca465f686f6a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9836011dde7a872bd5f9c7085e794496b969d7160bc3fff5b9310227a246530"
  end

  depends_on "freetype"
  depends_on "glew"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "sdl2"
  depends_on "sdl2_ttf"
  depends_on "tcl-tk"
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
    ENV["TCL_CONFIG"] = Formula["tcl-tk"].opt_lib

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
