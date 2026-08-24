class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/videolan/libbluray/1.5.0/libbluray-1.5.0.tar.xz"
  sha256 "f676408e91a5d321abf8b8d4dfdae36205c297dab5c54c3ec519639025f474a2"
  license "LGPL-2.1-or-later"
  compatibility_version 2
  head "https://code.videolan.org/videolan/libbluray.git", branch: "master"

  livecheck do
    url "https://download.videolan.org/pub/videolan/libbluray/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6f27f52be0330c4e36c59a6beb6a12255e8e6d51448d35d889246419d20ac042"
    sha256 cellar: :any, arm64_sequoia: "90d5839c5058c8fc7a1b5504a75c350bdd4ee65617a47c02c80d992fd3bba70c"
    sha256 cellar: :any, arm64_sonoma:  "ae06908b74795cee1c6f8a948fdd0e41cc3a9dad4130185a06960dec4851664b"
    sha256 cellar: :any, sonoma:        "eb3a8a82adba66a8c1d367a3165223069c66918b35876754c218bde0469c6887"
    sha256               arm64_linux:   "d817085614cd670762e86abb19cbded82790c5b2f32fe643b380c8a14f148593"
    sha256               x86_64_linux:  "8d08e2d914953f2b0737539958d5932ee1b22e7a67da4621df358913ada5ecb7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libudfread"

  uses_from_macos "libxml2"

  def install
    args = %w[
      -Dbdj_jar=disabled
      -Dfontconfig=enabled
      -Dfreetype=enabled
      -Dlibxml2=enabled
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libbluray/bluray.h>
      int main(void) {
        BLURAY *bluray = bd_init();
        bd_close(bluray);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lbluray", "-o", "test"
    system "./test"
  end
end
