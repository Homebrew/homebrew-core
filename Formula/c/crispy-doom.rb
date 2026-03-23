class CrispyDoom < Formula
  desc "Limit-removing enhanced-resolution Doom source port based on Chocolate Doom"
  homepage "https://github.com/fabiangreffrath/crispy-doom"
  url "https://github.com/fabiangreffrath/crispy-doom/archive/refs/tags/crispy-doom-7.1.tar.gz"
  sha256 "f0eb02afb81780165ddc81583ed5648cbee8b3205bcc27e181b3f61eb26f8416"
  license "GPL-2.0-only"
  head "https://github.com/fabiangreffrath/crispy-doom.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "cd4cfaa085f5e29518b82d35f277a6ee28b4829692a835858c40bc8a73ac6d8a"
    sha256 cellar: :any,                 arm64_sequoia: "557d17191cf33fe6facd8bad60d6f30db272a73c19d5d17059c65e2a4cf84c98"
    sha256 cellar: :any,                 arm64_sonoma:  "7c7bb72c1a9f054e2bf0a96b1e154f5f035c899c377fdd8fb417739e04cc5e90"
    sha256 cellar: :any,                 sonoma:        "1b6a55ca5f724065f392001873196c777625872d33572ccf5c6ea8bf2663639b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff2d4ad766f28347b84cf6917c3f64d5dabf225efb324c6ec741ec48d4abf718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a961d18f9165cc0e96cc09db90784312fec9e482afe2d091c3ed1051ad33b09e"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
