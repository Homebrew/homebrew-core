class Openmsx < Formula
  desc "MSX emulator"
  homepage "https://openmsx.org/"
  url "https://github.com/openMSX/openMSX/releases/download/RELEASE_0_13_0/openmsx-0.13.0.tar.gz"
  sha256 "41e37c938be6fc9f90659f8808418133601a85475058725d3e0dccf2902e62cb"
  revision 1
  head "https://github.com/openMSX/openMSX.git"

  bottle do
    cellar :any
    sha256 "c1e6ea05dffcbb8cddf8c337ffa994e75d2c2a010d52e1f439b087b1877a348b" => :sierra
    sha256 "7a3a81f1b96a95b5eb56372be2453e6c69c8e9c74b9ef653a815f7f31f05e8f5" => :el_capitan
    sha256 "4f13b58dfb328c94dec0d823780ff9eaf0e423ecf73abe913aae9d2280b95727" => :yosemite
  end

  deprecated_option "without-opengl" => "without-glew"

  option "without-glew", "Disable OpenGL post-processing renderer"
  option "with-laserdisc", "Enable Laserdisc support"

  depends_on "sdl"
  depends_on "sdl_ttf"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "glew" => :recommended

  if build.with? "laserdisc"
    depends_on "libogg"
    depends_on "libvorbis"
    depends_on "theora"
  end

  def install
    # Fixes a clang crash; this is an LLVM/Apple bug, not an openmsx bug
    # https://github.com/Homebrew/homebrew-core/pull/9753
    # Filed with Apple: rdar://30475877
    ENV.O0

    inreplace "build/custom.mk", "/opt/openMSX", prefix
    # Help finding Tcl
    inreplace "build/libraries.py", /\((distroRoot), \)/, "(\\1, '/usr', '#{MacOS.sdk_path}/usr')"
    system "./configure"
    system "make"
    prefix.install Dir["derived/**/openMSX.app"]
    bin.write_exec_script "#{prefix}/openMSX.app/Contents/MacOS/openmsx"
  end

  test do
    system "#{bin}/openmsx", "-testconfig"
  end
end
