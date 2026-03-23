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
    rebuild 1
    sha256                               arm64_tahoe:   "46a81649179f13aeb4dbe640364bdfe030a938cc3525ea6c9a98b1f8acaad069"
    sha256                               arm64_sequoia: "ad154d6eb85d59de2963c61e115e23100a9760636e574712b3dc74d83f5d9cfd"
    sha256                               arm64_sonoma:  "8104828bb93561629545c04e39343df59126e8097994aa09f45362be9f20dec5"
    sha256                               sonoma:        "975161e502be78f6a728b5eddbf51b40223ed0e3bdcaad650f187cfbd32194c9"
    sha256                               arm64_linux:   "4e42f23a5aa402cd7a2c12d5838a87f308115d247c86f24ae592c61f7a5f24b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5b373764af3cd9384c20e4db2a91de894c21044b47751c8795f7f629540a789"
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
