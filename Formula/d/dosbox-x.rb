class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v2025.12.01.tar.gz"
  sha256 "1777a5ff5ee214e2eb524740cee4b3299e87041ea7f9d8471b71d8003de210f1"
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
    sha256                               arm64_tahoe:   "890f79e8da608a79afd358d735cbec9939b1c21aff472fa64e83ecb3bdec0ad5"
    sha256                               arm64_sequoia: "202fedb32623c9f2a3721770529e5799ecfbf0e86bc2f180f01814a6413b3366"
    sha256                               arm64_sonoma:  "55eab25dba882282b9732af1bceb02970a820d80935e7444179f510a0bd57ad6"
    sha256                               sonoma:        "69a76fe894d0fd0748ec37f53576b0051111c07911ab4e858b33ac1006a6a1a9"
    sha256                               arm64_linux:   "bf79960c82005408647f8f49eaba6a4d5d2d301d55198f49ce72e13bde6871b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0926875272c6b112db4bc32aa20c8b589eb1a81fbffa0620666c0df6c2102223"
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
