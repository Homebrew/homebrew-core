class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "http://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.82.13.tar.gz"
  sha256 "e2721125b650ef995fc66f95766a995844f52aab0cf4261ff7aa998eb60e6f4c"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5bccafd80948d5ef2ef3059eae718d1c025880a83c065533daa7befe1bd4cae2" => :mojave
    sha256 "8cbaa0cf9658118b4b4ba32f4d1718f9bf49d0aec71cc7846463f37966559656" => :high_sierra
    sha256 "d3fc4b2bd340ed6f7d2624b8daf95397891f8e142d6219437f2cae215f538216" => :sierra
    sha256 "0b5098e3397a15804a300540be53c98f862c4f7276eb4c1de7966152421a9392" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "ffmpeg"
  depends_on "fluid-synth"
  depends_on "libpng"
  depends_on "sdl"
  depends_on "sdl_net"
  depends_on "sdl_sound"

  needs :cxx11

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
      --enable-core-inline
    ]

    # Upstream fix for parallel build issue, remove in next version
    # https://github.com/joncampbell123/dosbox-x/commit/15aec75c
    inreplace "vs2015/sdl/build-dosbox.sh",
              "make -j || exit 1", "make || exit 1"

    system "./build-macosx", *args
    system "make", "install"
  end

  test do
    assert_match /DOSBox version #{version}/, shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
