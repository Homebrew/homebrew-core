class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v2026.01.02.tar.gz"
  sha256 "191e5de64f19b26f5a78a05b70e3216d62f3eaf2d0495f6258a12213a3d691c9"
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
    sha256                               arm64_tahoe:   "7d44cb98ab9706fb3cd2565d04e52810e75d725ce8c89b304844019593b8069d"
    sha256                               arm64_sequoia: "17b050b27100667a068c451eb00e425a6b44a7a81ba71e2315788d16ba430989"
    sha256                               arm64_sonoma:  "8af02abe6bb49f4aa92cd414a768cdc3d526bab3616441ddd637b7021e518cef"
    sha256                               sonoma:        "b50881cddb629a6d20515fe8d0fac8e1dd6291c1b035bf49ec1d5329d9b2ab43"
    sha256                               arm64_linux:   "729937ce051cef8686d3832e67010cb4ee848431ca2a1933b5883006fd711344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "056fab36f82ab74ca4083422af5766006491ee2e45836508085d3f8258cb9d17"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "sdl2"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "glib"
  end

  on_linux do
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
    system "./configure", *args, *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make" # Needs to be called separately from `make install`.
    system "make", "install"
  end

  test do
    assert_match "DOSBox-X version #{version}", shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
