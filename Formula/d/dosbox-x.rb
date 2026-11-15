class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v2026.10.01.tar.gz"
  sha256 "df023a6c0e4a139dcbd60befff5947e0db2cc68e4e79db463670f581a4044ed4"
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
    sha256 arm64_golden_gate: "828ac729952d469ff3b14ceb62f6796a787a12f05d566ce7f236cfa674dc5b7e"
    sha256 arm64_tahoe:       "277c70e19dee2ea0603bb504331b35b46bf6d7027ec8a5d2f88fa06b6d12753a"
    sha256 arm64_sequoia:     "1a17b3e7dd0b7147b3c889e24a23ea03809d6e250cec08b424aacb2e408b5e50"
    sha256 arm64_linux:       "9debfd55ad10217e1348c312517442c63fe8db42e39e3cb54774da3d21382b4c"
    sha256 x86_64_linux:      "4d6e824cb4bf26af9891b2424cc157ab45dcc582d4d440b6e87703d13a48b826"
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

  deny_network_access!

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
