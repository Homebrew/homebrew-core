class Openmsx < Formula
  desc "MSX emulator"
  homepage "https://openmsx.org/"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/openMSX/openMSX.git", branch: "master"

  stable do
    url "https://github.com/openMSX/openMSX/releases/download/RELEASE_21_0/openmsx-21.0.tar.gz"
    sha256 "28838bfa974a0b769b04a8820ad7953a7ad0835eb5d1764db173deac75984b6f"

    # Backport fix for sdl2-compat
    patch do
      url "https://github.com/openMSX/openMSX/commit/bef559e0e2e1413ba8abbef882224a5919214c5a.patch?full_index=1"
      sha256 "3744a1693d43c86a678c416836f0e2fa900023f0b9176c63116080f009c5bbb9"
    end
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

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d119f746e37e9cc1f202e47bbeccd4a3a396164a451693b18e06bbbae098e0e4"
    sha256 cellar: :any, arm64_sequoia: "f3f25f04f4eb84bc2a4a7b1b70d03a5fc3340e2374f1813d1f2593970ce029db"
    sha256 cellar: :any, arm64_sonoma:  "3e1f9864913d165c6a61621c7b9b368dade12909e4e0d0e718bc4a20674e09f0"
    sha256 cellar: :any, sonoma:        "3bc8f45c362611a6679e1d53af5ff55eb1e93da2873fa53358481a91f360bea7"
    sha256               arm64_linux:   "cad529500c86d30ecc21ede35a5478e13e308701d45c2a863338ebe893228479"
    sha256 cellar: :any, x86_64_linux:  "909ffc1a07e59c33dfa4c6619b6917c01698af379533293d0a208cbe4524bf39"
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
