class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "https://mednafen.github.io/"
  url "https://mednafen.github.io/releases/files/mednafen-1.32.1.tar.xz"
  sha256 "de7eb94ab66212ae7758376524368a8ab208234b33796625ca630547dbc83832"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://mednafen.github.io/releases/"
    regex(/href=.*?mednafen[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "e100baeaab0eb1f32d42f02ed07741683c6e344d9df1a73498b5ae1388d69329"
    sha256 arm64_sonoma:  "1a44117a0ab7696c1fc8a53fe01857dc50c79687f22191b669cb3fb0ba2eb762"
    sha256 arm64_ventura: "41f73f24d64c67f03e321ca8c5e69cb63af7335865894bd977d1733ffc47a2dd"
    sha256 sonoma:        "64d38f660b3c5b464efe66424b0cbd5b20601a69a00b138733bc706ffa88cc55"
    sha256 ventura:       "b40afba5777537935fe7c79d0b275e0ef186d91d4220cdc82de150d31d212575"
    sha256 arm64_linux:   "3a7871f139d7ab711a311bf62be6de85445694aa79e0fb11f1e532d5600bce61"
    sha256 x86_64_linux:  "dfd1940dfa9917d20668ee7f53f30b682d49b6674a768b43dd77db6f181d135d"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build

  depends_on "flac"
  depends_on "libsndfile"
  depends_on "lzo"
  depends_on macos: :sierra # needs clock_gettime
  depends_on "sdl2"
  depends_on "zstd"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    # musepack is not bottled on Linux
    # https://github.com/Homebrew/homebrew-core/pull/92041
    depends_on "musepack"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "mesa"
  end

  def install
    args = %w[
      --with-external-lzo
      --with-external-libzstd
      --enable-ss
    ]
    args << "--with-external-mpcdec" if OS.mac? # musepack

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    # Test fails on headless CI: Could not initialize SDL: No available video device
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match version.to_s, shell_output("#{bin}/mednafen", 255)
  end
end
