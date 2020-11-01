class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.7.tar.gz"
  sha256 "9cdfa3267c340a869255d8eb1c4ebf4adde47c22854e1d013da22190350bfbb3"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  livecheck do
    url :head
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "d3a7ecf96b630239538d11aa11acab191f5ded6f66a89899c51c8b6906496058" => :catalina
    sha256 "beea0d34a53fb1cbe616d841033ab1e49d9375ae808bffd9dc78b89bbf90795a" => :mojave
    sha256 "627659d5d7f7c8696bdad82aca4870f90b38d84ba3751f2dd1497f545322cea9" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on macos: :high_sierra # needs futimens

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
    ]
    system "./build-macosx", *args
    system "make", "install"
  end

  test do
    assert_match /DOSBox-X version #{version}/, shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
