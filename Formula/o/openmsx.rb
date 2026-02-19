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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e5ae1c09d02fecd72160c6d855f89a4deba2bb7e772bbc2786de450ecb4c9fa5"
    sha256 cellar: :any,                 arm64_sequoia: "4f595788d6873c14cfa8466a1c20ea54a5e126fa9ec5eb22324062360ce31ea1"
    sha256 cellar: :any,                 arm64_sonoma:  "239315047c4a68e4c4dc241791cfdd50491c4423ed61177cc751f13482df41c0"
    sha256 cellar: :any,                 sonoma:        "79258e774e8e2ab3b893546a75ef070bc40ff80cae847619c47b4a8405f00923"
    sha256                               arm64_linux:   "b40df8913652a5d810da13e575a6c3a32293ecbc9310e7be18c12090c7dbda10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5879ce754cabf63705ab53bbf4620d882611e4106b87bca5567f818db5d4b97"
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

  on_ventura :or_older do
    depends_on "llvm"

    fails_with :clang do
      cause "Requires C++20"
    end
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  fails_with :gcc do
    version "7"
    cause "Requires C++20"
  end

  def install
    if OS.mac? && MacOS.version <= :ventura
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
