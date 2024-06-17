class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v2024.03.01.tar.gz"
  sha256 "2a89d3196ddc15361f6dc7e6ab142bfe95945d93d527cfd6bacca1f7a401a513"
  license "GPL-2.0-or-later"
  revision 1
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git", branch: "master"

  # We check multiple releases because upstream sometimes creates releases with
  # a `dosbox-x-windows-` tag prefix and we've historically only used releases
  # with the `dosbox-x-` tag prefix. If upstream stops creating `...windows-`
  # releases in the future (or they are versions that are also appropriate for
  # the formula), we can update this to us the `GithubLatest` strategy.
  livecheck do
    url :stable
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 arm64_sonoma:   "831bb184856ac27d26858adbe9ccea37f5ee56e43fcab7b8231a0e8e83f9acef"
    sha256 arm64_ventura:  "b24ce13996abe1b79ae0ce7d598287627b7b64877f12e5ed9f3de88e8bd46dd4"
    sha256 arm64_monterey: "37e29dbda2a1756471050cf0f37fef0667444f96aec8b3beb256845bd550c030"
    sha256 sonoma:         "1a3e023ed387c4a98d1a89b4ba0b2d372ee5fb1847f3d89eeb923dec4dcbadde"
    sha256 ventura:        "2b70b9b6a2a96f7e401639d019c7290a5af72c3d88c6a8a3002801984f693302"
    sha256 monterey:       "294c93bd3d3bf73eae34227090a61aa0754a5478236af06fd084d357599ce47f"
    sha256 x86_64_linux:   "fdc386db0517932d64d9071c10268ce671aad990e1351fe37732cc200edf7d1a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on macos: :high_sierra # needs futimens
  depends_on "sdl2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-headers@5.15" => :build
  end

  fails_with gcc: "5"

  def install
    ENV.cxx11

    # See flags in `build-macos-sdl2`.
    args = %w[
      --enable-debug=heavy
      --enable-sdl2
      --disable-sdl2test
      --disable-sdl
      --disable-sdltest
    ]

    system "./autogen.sh"
    system "./configure", *std_configure_args, *args
    system "make" # Needs to be called separately from `make install`.
    system "make", "install"
  end

  test do
    assert_match "DOSBox-X version #{version}", shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
