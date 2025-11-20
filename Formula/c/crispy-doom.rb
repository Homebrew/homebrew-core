class CrispyDoom < Formula
  desc "Limit-removing enhanced-resolution Doom source port based on Chocolate Doom"
  homepage "https://github.com/fabiangreffrath/crispy-doom"
  url "https://github.com/fabiangreffrath/crispy-doom/archive/refs/tags/crispy-doom-7.1.tar.gz"
  sha256 "f0eb02afb81780165ddc81583ed5648cbee8b3205bcc27e181b3f61eb26f8416"
  license "GPL-2.0-only"
  head "https://github.com/fabiangreffrath/crispy-doom.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eea3fa7dc16aaa3a18807238c95263dcd290e04d8d9e893959d75f7fcc708059"
    sha256 cellar: :any,                 arm64_sequoia: "c12f350743f1a9d205256cf1ee7ecd86e0f80a9f67d5815ad09ca85c6aaa3a96"
    sha256 cellar: :any,                 arm64_sonoma:  "af9be4cadc170f38e4268496261f83f4ebe1c28d713168c7c926ddcaa0417fce"
    sha256 cellar: :any,                 sonoma:        "d0cace8c3b2d61918d02efbf75187e3257791d96926d63a8cfb308b83f24d999"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "371753cc38f1f6d57feafe1a9c0fb10ed1d7b90120dbc873426d80b62876528f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "460172d447f43fa89378fc732207f52c113c8588960c67b0df061c9b059c47fd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "fluid-synth"
  depends_on "libpng"
  depends_on "libsamplerate"
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "sdl2_net"

  uses_from_macos "zlib"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules",
                          "--disable-sdltest",
                          *std_configure_args
    system "make", "install", "execgamesdir=#{bin}"
  end

  test do
    testdata = <<~EOS
      Invalid IWAD file
    EOS
    (testpath/"test_invalid.wad").write testdata

    expected_output = "Wad file test_invalid.wad doesn't have IWAD or PWAD id"
    assert_match expected_output, shell_output("#{bin}/crispy-doom -nogui -iwad test_invalid.wad 2>&1", 255)
  end
end
