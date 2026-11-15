class Openmsx < Formula
  desc "MSX emulator"
  homepage "https://openmsx.org/"
  url "https://github.com/openMSX/openMSX/releases/download/RELEASE_22_0/openmsx-22.0.tar.gz"
  sha256 "f6d5ff89c62d32447dd5f731ff653d26a2a3c4ac6e86ea4f1bda3c4f8ad98c5d"
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
    sha256 cellar: :any, arm64_golden_gate: "2ae66970aac4664f3373b1b892da9efabc19ed01193dabf4c09ac8fd3261ec68"
    sha256 cellar: :any, arm64_tahoe:       "23a7bb25f72ddfe64eed971fdaa8b1fd566f49dcadfe6eadcaa888e760b1c988"
    sha256 cellar: :any, arm64_sequoia:     "13d30058a4ea35d335fb7346384ed4a55a4b3c5c7577c15b30b296c2b65228af"
    sha256               arm64_linux:       "630da52fe283a2255a4f519e7b89b59af4c014699a8c48d14cfe3dce053a66b7"
    sha256 cellar: :any, x86_64_linux:      "33c9c41de524de68fb790f3cb56557443403888299bfc68bbb68ea29911c5a46"
  end

  depends_on "freetype"
  depends_on "glew"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "sdl2-compat"
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

  deny_network_access!

  def install
    if OS.mac? && MacOS.version <= :ventura
      ENV.prepend "LDFLAGS", "-L#{formula_opt_lib("llvm")}/unwind -lunwind"
      # When using Homebrew's superenv shims, we need to use HOMEBREW_LIBRARY_PATHS
      # rather than LDFLAGS for libc++ in order to correctly link to LLVM's libc++.
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", formula_opt_lib("llvm")/"c++"
    end

    # Hardcode prefix
    inreplace "build/custom.mk", "/opt/openMSX", prefix
    inreplace "build/probe.py", "platform == 'darwin'", "platform == 'linux'" if OS.linux?
    inreplace "build/probe.py", "/usr/local", HOMEBREW_PREFIX

    # Help finding Tcl (https://github.com/openMSX/openMSX/issues/1082)
    ENV["TCL_CONFIG"] = formula_opt_lib("tcl-tk")

    args = %W[
      CXX=#{ENV.cxx}
      LDFLAGS=#{ENV.ldflags}
    ]
    args << "OSX_VER=#{MacOS.version}" if OS.mac?

    system "./configure"
    system "make", *args

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
