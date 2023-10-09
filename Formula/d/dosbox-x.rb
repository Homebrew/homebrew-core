class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v2023.10.06.tar.gz"
  sha256 "65f756e29f9c9b898fdbd22b0cb9b3b24c6e3becb5dcda588aa20a3fde9539a5"
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
    sha256 arm64_sonoma:   "5d62865c88ef4fb50cba6c57bff513894bb3f030245cc1aa06e748113cfba27f"
    sha256 arm64_ventura:  "89d237442159c3b04037ea05163933ebcfe4eba76053f36357ee71b2c032c22b"
    sha256 arm64_monterey: "a318f15ca4ddbb5f70234ea43e62e41f277a8fa3f72994a04022326c5b85ed4f"
    sha256 sonoma:         "4155241a567c1ab6b2b274e9376c47f0a32c7b5178c5816e6c9b02a0b52f5c64"
    sha256 ventura:        "ca8134d14440c01c9437238fccd839fcc856630cba0903a0b3fbf8388b9fd383"
    sha256 monterey:       "e0dafed0d01b3c42feb7459248ae4ce4bfb01c9c2ecc156f49b4e720e500ab32"
    sha256 x86_64_linux:   "dd48874cc427f766b6e17d609f0d1fa7e86ea373b0b68648bd85c2f23139dfe1"
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
