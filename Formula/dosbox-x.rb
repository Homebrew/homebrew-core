class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v2022.12.26.tar.gz"
  sha256 "39fb1ed19ea31e11883aa57655493b3100ac6b328ef59c799b840b9bfdfacb7b"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git", branch: "master"

  livecheck do
    url "https://github.com/joncampbell123/dosbox-x/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/dosbox-x[._-]v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 arm64_ventura:  "c7be8befe2e5bda8174eda6eb438c5881d486cfb1e69a1d797d7b08085339404"
    sha256 arm64_monterey: "70a6c5635e729309c2d7c10fb2e3cfaa7b2fc5d3d37a806e8c9d9c948dbca184"
    sha256 arm64_big_sur:  "90604f59a07a685de25b5e6d0f5d9c3b48b5cd78e779ffedb7e8788ccc34529a"
    sha256 ventura:        "ea87e7596faa4d3f1118e467316ec9d82c2989ea64addf092688d7414c3fb11d"
    sha256 monterey:       "808eeb990657c9ebd14b9fe39a8110e6fe224591aba88c8b98e65581a3de41eb"
    sha256 big_sur:        "cbbf7b78a0423a11537634696f66441cc2ad1fff60bd833ebbb260833a874871"
    sha256 x86_64_linux:   "a5cfcd3a81bf420eb2b0bc4ddf421b1be94deb98a90485043578723f9448955d"
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
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-headers@5.15" => :build
  end

  fails_with gcc: "5"

  # upstream PR ref, https://github.com/joncampbell123/dosbox-x/pull/3907
  # remove in next release
  patch do
    url "https://github.com/joncampbell123/dosbox-x/commit/b9ba6fba0dd0dc7fbeaa083de9d338564e8a6407.patch?full_index=1"
    sha256 "f8173ce0560d6a5d36f00c3c1fbef03c22b6006c76d70fb311f3af54edc3de85"
  end
  patch do
    url "https://github.com/joncampbell123/dosbox-x/commit/2dbbfff7407cb87d618ac341567e3c0ab1c03c6e.patch?full_index=1"
    sha256 "573b6cfc9fe2f9a297c11c6c272b1b2296bab183ff3037455c76bcba077d589a"
  end

  def install
    ENV.cxx11

    # See flags in `build-macos-sdl2`.
    args = %w[
      --enable-core-inline
      --enable-sdl2
      --disable-sdl2test
      --disable-sdl
      --disable-sdltest
    ]

    system "./autogen.sh"
    system "./configure", *std_configure_args, *args
    system "make" # Needs to be called separately from `make install`.
    system "make", "install"
  end

  test do
    assert_match "DOSBox-X version #{version}", shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
