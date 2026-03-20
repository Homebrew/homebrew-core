class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/videolan/libbluray/1.4.1/libbluray-1.4.1.tar.xz"
  sha256 "76b5dc40097f28dca4ebb009c98ed51321b2927453f75cc72cf74acd09b9f449"
  license "LGPL-2.1-or-later"
  head "https://code.videolan.org/videolan/libbluray.git", branch: "master"

  livecheck do
    url "https://download.videolan.org/pub/videolan/libbluray/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3895fef0bbc04ee7271992f3908569416a67d97efba1c492a4ccc053de0a89c3"
    sha256 cellar: :any, arm64_sequoia: "f20ad084fb722697dd0658fb7de27d94497f5849fd18fa3aacba1e2ea664fbc6"
    sha256 cellar: :any, arm64_sonoma:  "fa3daea45cc9170bcb15d3d8fd7b238ebdb75ec241afe1488d57dbd7559d9982"
    sha256 cellar: :any, sonoma:        "1aa87a3cf82c6b914c78856a9283e838e1d7426f4d1377537dae81e1041f64b0"
    sha256               arm64_linux:   "0839ef787f9411f8056674b5f7e1dd7e68d5b5df330a11ed1e845f1635683ef1"
    sha256               x86_64_linux:  "153b38bf91479d363e0dcaaef4ddebc96793a7db980baa3993a56f5a0082e477"
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
