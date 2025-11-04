class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/videolan/libbluray/1.4.0/libbluray-1.4.0.tar.xz"
  sha256 "77937baf07eadda4b2b311cf3af4c50269d2ea3165041f5843d96476c4c92777"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://code.videolan.org/videolan/libbluray.git", branch: "master"

  livecheck do
    url "https://download.videolan.org/pub/videolan/libbluray/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0ec773a6a338ab74b0e563a13065853d94252ff2c8adbbe5758bed9086d052de"
    sha256 cellar: :any, arm64_sequoia: "b14c0952114a372fe73e50c6110b8970e01e6e0d5227c5357bc0080a0a0033c6"
    sha256 cellar: :any, arm64_sonoma:  "dbe261eb5439a5343510b81e30df6c594a92fc9cedd079ada19b2f8967d26541"
    sha256 cellar: :any, sonoma:        "fa37611ed58f0f605ed1851b67c3b06ea40072b08f2470b82aaa2d831e94bf03"
    sha256               arm64_linux:   "ed084dfc530c28566bf359d39ca0c163e996c9fba68ebc96446e83e2638ed68f"
    sha256               x86_64_linux:  "e31331a46d51e377ef252a0ed10aec41479d35dd99e58a67c2420dfc419cd901"
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
