class Enigma < Formula
  desc "Puzzle game inspired by Oxyd and Rock'n'Roll"
  homepage "https://www.nongnu.org/enigma/"
  url "https://github.com/Enigma-Game/Enigma/releases/download/1.30/Enigma-1.30-src.tar.gz"
  sha256 "ae64b91fbc2b10970071d0d78ed5b4ede9ee3868de2e6e9569546fc58437f8af"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "9478e81c3ee868cd66ce678e1f1ab6954b10e6bd8f0e7684582fff08a7f7d3c4"
    sha256 arm64_sequoia: "74e171cc98605dac471473d3b109615436da5f01efe97a6bef87863df29228e6"
    sha256 arm64_sonoma:  "80d1c3b6996e2654de90d74c8b64156f0ab114e9f6a0ca23a9ef8ac2ad4e15b6"
    sha256 arm64_ventura: "72b381ad60a3599e47c1e0a76b74ab074645c75e21fcf007849eb9b3461604ca"
    sha256 sonoma:        "9a282238a0694092cd68cebd03651c6f42f19050adf5957b31d07b784b738fc2"
    sha256 ventura:       "65581f9d70099db6bc6a45d12b1d7ec373bfc50285ffd244d67b06bcd9a82023"
    sha256 arm64_linux:   "35ff0e6572e4cdc889ff3addde96415c9df3cafe24ea3609bad6541fc15cc119"
    sha256 x86_64_linux:  "b853cd4b2c13e10445b12737298e51293e282319bc5f27ceb424e7746a79adc5"
  end

  head do
    url "https://github.com/Enigma-Game/Enigma.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "texi2html" => :build
  end

  depends_on "imagemagick" => :build
  depends_on "pkgconf" => :build

  depends_on "enet"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"
  depends_on "xerces-c"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--with-system-enet", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "Enigma v#{version}", shell_output("#{bin}/enigma --version").chomp
  end
end
