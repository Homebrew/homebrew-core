class Openmsx < Formula
  desc "MSX emulator"
  homepage "https://openmsx.org/"
  url "https://github.com/openMSX/openMSX/releases/download/RELEASE_21_0/openmsx-21.0.tar.gz"
  sha256 "28838bfa974a0b769b04a8820ad7953a7ad0835eb5d1764db173deac75984b6f"
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

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f163141e884181d6ddc1dfec63acfde452c26af4bc20cd424756b96f199cdf4d"
    sha256 cellar: :any,                 arm64_sequoia: "524064efe7274201bd28490cb9b515429efa67ffbd072f84528d8f94f4485123"
    sha256 cellar: :any,                 arm64_sonoma:  "1e2a22829a8bc5ff0cfa1ed57d89d016c3d071720d419dfb7b9ca921c0f44618"
    sha256 cellar: :any,                 sonoma:        "4994c71b8a54a53fc30e51a56b4fc71076550a4f0e186a0e84b6188d6ddb1e27"
    sha256                               arm64_linux:   "74a866c43df3f6ecccfe78e8164b37eb5d365f68a6d2dee9f72cb5dec3f03b72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25c217d5db0b730426c2afa84ef465e4b5f60b29659c91f8fc6f58382a0f4673"
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
