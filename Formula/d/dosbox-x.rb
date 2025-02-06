class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v2025.02.01.tar.gz"
  sha256 "3a6fdfd659bb05db82bf2d850af806f666562cce9a37609fd33b59f7e4bd8fa4"
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
    sha256 arm64_sequoia: "1915228ad714219b91d754889b3b7b0697759e4681bb1a93df33451455a64529"
    sha256 arm64_sonoma:  "c586e33b8b2c38d8e44a4aef206dd9663b11f4c2ea082f125527bb32e5fe9e1a"
    sha256 arm64_ventura: "10d53f31e326cc287bf4a006fc5390c1b073339b2cc012a914a91eaeddc844e8"
    sha256 sonoma:        "bb9d3461045d8c5890ddf4dc8ccfd280fa3a48f9986896813c4d8af10cbb2a56"
    sha256 ventura:       "4f24307a90518152e0b8d2658ab3965d22581156db1bea3a11a014af228d46bf"
    sha256 x86_64_linux:  "be98a10835a52e665f2b8cb803a7f41d34383a358bbed82d355621f56bdc6db7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

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
