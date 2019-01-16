class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "http://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.82.13.tar.gz"
  sha256 "e2721125b650ef995fc66f95766a995844f52aab0cf4261ff7aa998eb60e6f4c"
  revision 1
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  bottle do
    cellar :any
    sha256 "16010137841ad1a80bd7994f94013087339c2b3edf8c842ab7906872531e1a3e" => :mojave
    sha256 "0b3459029756df719fa4a4bf87b45c878df887622be43436ceb30a3e7d29390a" => :high_sierra
    sha256 "cde277ce3239bd99c0d177491bd973dd6f81ec1a34c8f7ddd75c4c57da20d410" => :sierra
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
