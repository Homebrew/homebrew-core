class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.12.tar.gz"
  sha256 "31e2e9943a0e4d888402ed6289c7b0d60df049bedf62e4518c9bc0ca903f8b19"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  livecheck do
    url :stable
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d80ee8971aa99f3444094d1fd4c501c8f9a5f6e27a1d6b804e478ae0d1de2bcf"
    sha256 cellar: :any, big_sur:       "7261f2fa1ec029627fe3e852d7be65338fe5abd8b08c4d5e7aa53793894e50f2"
    sha256 cellar: :any, catalina:      "fc3bbe22b89352dcbeb7d62e16fea1970dd3eb61436e647d3048115c814498b0"
    sha256 cellar: :any, mojave:        "11183db1b9790329232f795a1e26ee7944190d67c1a62963cbeaadafd349131d"
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
    assert_match "DOSBox-X version #{version}", shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
