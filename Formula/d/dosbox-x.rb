class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v2023.05.01.tar.gz"
  sha256 "0aa75b873978aec41ecfee62bb103d8a17fe3566a3ebf5415245cee0dd032ebb"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git", branch: "master"

  livecheck do
    url "https://github.com/joncampbell123/dosbox-x/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/dosbox-x[._-]v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 arm64_ventura:  "89dae5ac74ff447c36d42c31853f4e508ba2b29fc298922731b3a323eae4cf2d"
    sha256 arm64_monterey: "28fe74aaed1dc8e5e6821dbb0824fb9169cd8a3988f5eae3f964af96d09ea1ce"
    sha256 arm64_big_sur:  "d47e4223e48dcb353844fe1248c9f8fd87fed18effdf9a503ac6f90c165104c6"
    sha256 ventura:        "9fee80e8182e9bf33964199007aa18e9350a7641b72f738448f5f2dffad3c72d"
    sha256 monterey:       "bd64240e9131f534bf6c9cbf9773d644036870b5ea0a34898eec7dbec2918b28"
    sha256 big_sur:        "a351f7daf2be8a72c1976cd050c38519c0227c7807d6282622e552b06bc6aceb"
    sha256 x86_64_linux:   "271467270b225ed90b3883c583b7e2d2e5e68aa86ae6c5173e00e5d16f567f9d"
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
