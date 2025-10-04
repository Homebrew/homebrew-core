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
    rebuild 1
    sha256 arm64_tahoe:   "2e8e7a500b841dcafc2bfcd58f95fbbf514ffcfb14646bf70d261934e1916c18"
    sha256 arm64_sequoia: "3ebf9988b2e260b9a1f755f8fcbcc0c9fa3411aae100594a99c03cded175f65c"
    sha256 arm64_sonoma:  "e52bfc223726a04f7d2b656a57ea9f24b5922e281c7cc3eb63260897dc4e11a7"
    sha256 arm64_ventura: "687f37db2e0fb19df00cca7bede658f0c368e5f603f09426bdac47a84e21868d"
    sha256 sonoma:        "a02749da55b8a46eda51ff89764d32975c0394ef28f9536958c33242f9b13e1d"
    sha256 ventura:       "6773d3660de92be32485d0330f751f38711356b0891bcdc1eaad88d1538e8a77"
    sha256 arm64_linux:   "35d7424987d439d2836e2d36c6c619285a9c97a854de09503502fa04d8294d4f"
    sha256 x86_64_linux:  "1c664519605f10515de616e8d8559b33c46764c1d259f66e21ef5c2fa3131d9a"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build

  depends_on "flac"
  depends_on "libsndfile"
  depends_on "lzo"
  depends_on "musepack"
  depends_on "sdl2"
  depends_on "zstd"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "mesa"
  end

  def install
    args = %w[
      --with-external-lzo
      --with-external-libzstd
      --with-external-mpcdec
      --enable-ss
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    # Test fails on headless CI: Could not initialize SDL: No available video device
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match version.to_s, shell_output("#{bin}/mednafen", 255)
  end
end
