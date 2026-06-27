class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v2026.06.02.tar.gz"
  sha256 "763d4dfc4f2f9f3d7db550a434db44e9435d1ab4c6459da7373852f1d5dd56f0"
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
    sha256               arm64_tahoe:   "e0c643c204813ed9d25afae6c2d9112f6a25e5b126553980941352e3e6f7e19e"
    sha256               arm64_sequoia: "f35d0c029050911383efb4b6623aeed95ef6cc29687c7ac2375b6345aaac4b85"
    sha256               arm64_sonoma:  "08cfa45abcbb0baa3e130404a22f558bfa2a0ea14a92732871188472062f452f"
    sha256               sonoma:        "2edbc39a04e63939c1f71c2257c8cac46d0f1b9959273b1e48373f6d29b734bd"
    sha256               arm64_linux:   "2d3f460d807fe642fb39789ecc9f1bd4b2ea6b88f8b26a3a183ec2c2d2a25f64"
    sha256 cellar: :any, x86_64_linux:  "eab6f4370e38c207c4819048d988f4ad40b385ad528a24365c0b7d39734a2479"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on xcode: :build # For metal
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "sdl2-compat"
  depends_on "sdl2_net"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
    depends_on "glib"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "libxrandr"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.cxx11

    # Set `LDFLAGS` to link against the Metal and QuartzCore frameworks on macOS Ventura and later
    # during ./configure to detect the Metal framework
    ENV.append "LDFLAGS", "-framework Metal -framework QuartzCore" if OS.mac? && MacOS.version >= :ventura

    args = %w[
      --enable-debug=heavy
      --enable-sdl2
      --disable-sdl2test
      --disable-sdl
      --disable-sdltest
    ]

    system "./autogen.sh"
    system "./configure", *args, *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make" # Needs to be called separately from `make install`.
    system "make", "install"
  end

  test do
    assert_match "DOSBox-X version #{version}", shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
