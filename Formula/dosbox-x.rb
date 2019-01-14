class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "http://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.82.13.tar.gz"
  sha256 "e2721125b650ef995fc66f95766a995844f52aab0cf4261ff7aa998eb60e6f4c"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  bottle do
    cellar :any
    sha256 "244edf71defb57e0153f4fd598600de280a9ddd0797951c573a0ded123a62fb3" => :mojave
    sha256 "7f4167a2d651ef24554671e0b91c5645f551929cb8922f33e7e40e0861ad9da5" => :high_sierra
    sha256 "b1d6dc51c759cd666e58e808b022c2a374f5daa6ebadfbc796b19f1d2dccdf36" => :sierra
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
