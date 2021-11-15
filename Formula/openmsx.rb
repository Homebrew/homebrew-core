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
    sha256 cellar: :any, arm64_monterey: "8973febf561305e42e379c90018c1f09d5ab18129c36f41fdd07ee1677d017ca"
    sha256 cellar: :any, arm64_big_sur:  "1a4c53f573b29eaef8b6454622bd18e02b0369b8bc9c5e51493d0b2022b10b9b"
    sha256 cellar: :any, monterey:       "776c25742abbda02e552f0401268c3ee623cfdf1cca5078fdcb95b9077898fbd"
    sha256 cellar: :any, big_sur:        "7204df7abcba41b2a74ba2d6b969b610a56bf36e332a9f25c280bd74c88ddc87"
    sha256 cellar: :any, catalina:       "1a5c7befdf1a6faa24d6a1043c6bc2ee722cb118b8bb788323f01434d15e94b3"
    sha256 cellar: :any, mojave:         "57e29bb1e9e2ed95d628b7933c1929eb99da46f9bfc4885bc9b072a94afd6c0e"
  end

  depends_on "python@3.9" => :build
  depends_on "freetype"
  depends_on "glew"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "sdl2"
  depends_on "sdl2_ttf"
  depends_on "theora"

  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    # Hardcode prefix
    inreplace "build/custom.mk", "/opt/openMSX", prefix
    inreplace "build/probe.py", "/usr/local", HOMEBREW_PREFIX

    # Help finding Tcl (https://github.com/openMSX/openMSX/issues/1082)
    ENV["TCL_CONFIG"] = "#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework" if OS.mac?

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
