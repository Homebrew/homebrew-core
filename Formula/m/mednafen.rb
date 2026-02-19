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
    rebuild 2
    sha256 arm64_tahoe:   "2145cf181313a45d6c144a8050fd7c81a53346b15aa5283772b2b3ed4ab7e831"
    sha256 arm64_sequoia: "212f9102b71ec08e7ecc343d9a71dfae00d614b686d6ba493e0fb8634566c5fd"
    sha256 arm64_sonoma:  "61361a259b71446de15e5b2a5d76e018dcd466356ee40ffdc93a5069f1af4eb5"
    sha256 sonoma:        "3606d9e9e61a51287d17f1d7d6816d78755a8501ec1cf9569bec3c7ad80d4afd"
    sha256 arm64_linux:   "0025b636b515e34cd89e39b43b14f2886d8d5cb7257b9a994027fefbbf5d34d7"
    sha256 x86_64_linux:  "6f13f9eb2ea6d1a62eae0c6f9cfcb5e37d2b13db516568d0a7a38a823aeef010"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build

  depends_on "flac"
  depends_on "libsndfile"
  depends_on "lzo"
  depends_on "musepack"
  depends_on "sdl2"
  depends_on "zstd"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
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
    assert_match version.to_s, shell_output("#{bin}/mednafen", 255)
  end
end
