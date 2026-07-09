class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v2026.07.02.tar.gz"
  sha256 "ca380ea617ce2d9165f379e6d01a481ec5a26fcf4fa31490e1e04ffdb4030730"
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
    sha256 arm64_tahoe:   "a2ef454bbceff491e12fb54f4238654edd6ff2d4783f70daf698852b97c34a44"
    sha256 arm64_sequoia: "d4b0e25ed1df98dc8b36c0045667a81e578309184d228fb5978fcf8b95b0125d"
    sha256 arm64_sonoma:  "99d727bdfaee3201e22b50d2120cee088a348fd5b5b501ab3bccf34b45a7564f"
    sha256 sonoma:        "577aa37c151f5f4d22aab0e5736856b0237f973ef8c39d60e918ebbb89d2d367"
    sha256 arm64_linux:   "5113394fad3191ace236154d86067c21bd70b69b2cce020cf09700a58293dc96"
    sha256 x86_64_linux:  "f220a8341a57d9b9055fba01c81a0410fd4962cb1756a50e4020d8f1b1bcf8fb"
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
