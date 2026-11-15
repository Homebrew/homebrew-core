class CrispyDoom < Formula
  desc "Limit-removing enhanced-resolution Doom source port based on Chocolate Doom"
  homepage "https://github.com/fabiangreffrath/crispy-doom"
  url "https://github.com/fabiangreffrath/crispy-doom/archive/refs/tags/crispy-doom-7.2.tar.gz"
  sha256 "8fc243bd8c29a17f7e25b5dc367ef93e4d727955d7f731ee4d743eb32445b74c"
  license "GPL-2.0-or-later"
  head "https://github.com/fabiangreffrath/crispy-doom.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b18703980814c932ae74fab69cd3198d27dd4bb8f24e321c5498f5f7a75c3073"
    sha256 cellar: :any, arm64_tahoe:       "6ba699a2c380a09c3bed4aabde2146c4db5c5e6a78461dda9246878523f0f943"
    sha256 cellar: :any, arm64_sequoia:     "f2d457f589d7ef6fdef8be3a8c52dc2d4b4262f95f4615aafff7c51d60daecea"
    sha256 cellar: :any, arm64_linux:       "5f00ac617b3a4ec6bd3ae6a30eab1a8bd904d4d89c88f539b379487731b8f2f9"
    sha256 cellar: :any, x86_64_linux:      "40c0791233fca45518c3230fc7f4319ab6a9a41796100ecac915897d103a3533"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "fluid-synth"
  depends_on "libpng"
  depends_on "libsamplerate"
  depends_on "sdl2-compat"
  depends_on "sdl2_mixer"
  depends_on "sdl2_net"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
