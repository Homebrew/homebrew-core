class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v2024.07.01.tar.gz"
  sha256 "23462a3398303f8558e86973af9ba5d3d6d53bdaf324ec749610f2baf1dd449b"
  license "GPL-2.0-or-later"
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
    sha256 arm64_sonoma:   "7a1799bfeb379368eada7999470ec97561992190d0efdafc9bec2ebdeddc1169"
    sha256 arm64_ventura:  "d06034ea8c332aff03917656d4dc9eae12332f187466bc399be6d0357cb1ec05"
    sha256 arm64_monterey: "0ddb17ee7afe510d74420bb6c689b6da2a1f7897ad44248b4c72d1068f34c28c"
    sha256 sonoma:         "db5e1a4c59b8c8a9d4be01112bfaade0b90391fef49d7aafec424dd3d8068b09"
    sha256 ventura:        "143e759651f1d7f8f8f905a1faefe14b22d66f87f57f35ee6ecf4fa1f846efbc"
    sha256 monterey:       "c8e06ad5769214ee34bc7c09f424415e5a134da58469fbfbbbdb60f072ffd313"
    sha256 x86_64_linux:   "0ec1091bad54cf93e3658cc989b46280e1b9a21ca338c7119dc3874bf68cae65"
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

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "glib"
  end

  on_linux do
    depends_on "linux-headers@5.15" => :build
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "libxrandr"
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
    system "./configure", *args, *std_configure_args
    system "make" # Needs to be called separately from `make install`.
    system "make", "install"
  end

  test do
    assert_match "DOSBox-X version #{version}", shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
