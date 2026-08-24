class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v2026.08.02.tar.gz"
  sha256 "3438f3199dc301d7fdd1ab8ce44877c1755158e699b8deab21a7ad2c43cc0331"
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
    sha256 arm64_tahoe:   "e535ec90b8f9bb68c246f125360e0e36ba675fed87ed9b078632e0751dde8764"
    sha256 arm64_sequoia: "acf2bef5841ad923576aee1bf6c46e66c9d069ca5400509ea05d99fa6ab22224"
    sha256 arm64_sonoma:  "845e646a0eefd605c16131e374710af9ad46d93bdb4bb1058132801783e055d1"
    sha256 sonoma:        "37d345acdd91599261e53b2efa161c5c168ca98fa582259eb5d44544f9109ffe"
    sha256 arm64_linux:   "19c7c430493a5b6bb9156d8c88ef2f14caeb80fa29acdb9dc2fc0ab23719d75e"
    sha256 x86_64_linux:  "f3d4c0f911fee2c3f7e278e4b4a79e16b4dac8c03cb42433ecac7fcf15c67b81"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "sdl2-compat"
  depends_on "sdl2_net"

  uses_from_macos "ncurses"

  on_macos do
    depends_on xcode: :build # For metal
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
