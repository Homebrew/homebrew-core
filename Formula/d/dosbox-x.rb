class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v2026.03.29.tar.gz"
  sha256 "c244c1910444a0ad886d9bae05cc72b3ef036e340d5e2fc33edf364c0dce344e"
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
    sha256                               arm64_tahoe:   "abfe3c35d1a3a979b7ffba33d3935bfdd2d9f7d66d99d584bba15146cdb00826"
    sha256                               arm64_sequoia: "25910f23fb9886b8d53eef621d04e1bba16ffca3208539909535c59e8b4acd04"
    sha256                               arm64_sonoma:  "ee50d893c8d2a91fd4bf2499839907f5c44a4593a62b8adefee498031fd67f81"
    sha256                               sonoma:        "adf6f26f58dda10a72fbe863da1d020e8f5324a11cbd2d38c2d969cfa366ec4c"
    sha256                               arm64_linux:   "8f1a3554eb1c1f31fde14c65d85c47e799edd76633d3070c796117a3af5aa657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d40415deaa37d47ce17b189af832bbf90902e9486891157219bc0a354325ebdd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on xcode: :build # For metal
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "sdl2"

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
