class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/videolan/libbluray/1.4.0/libbluray-1.4.0.tar.xz"
  sha256 "77937baf07eadda4b2b311cf3af4c50269d2ea3165041f5843d96476c4c92777"
  license "LGPL-2.1-or-later"
  head "https://code.videolan.org/videolan/libbluray.git", branch: "master"

  livecheck do
    url "https://download.videolan.org/pub/videolan/libbluray/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6d5900d7399a70d07ceee573051914a3df9dac1b64eeb8e0ea6dc85d0ab5370b"
    sha256 cellar: :any, arm64_sequoia: "c0de9ea880e1f735514ed9857c8c862b37fb3cfdca7c929e8f0ef334900b7864"
    sha256 cellar: :any, arm64_sonoma:  "5d85e63aaf5ce3cf414ae9d0a8f6a274e4899dd8fdeabb249799cc5237644498"
    sha256 cellar: :any, arm64_ventura: "0a29f835646644de3a4933c9a56d9555683311f1c5f05bd2160e9ff0bddd77cd"
    sha256 cellar: :any, sonoma:        "e2b27ef091b17aaf34664816d28ca6586e76930b53b65d5e39b05f4f3e8cddbc"
    sha256 cellar: :any, ventura:       "f31c8017c1892bf08afe674a68ae7ebd08c7c5624903ee7e5ae6a31a17ea957b"
    sha256               arm64_linux:   "10279aae15df24736310c22e8680e5e2d803a6d6a8b3e2c478dadfdf189e540e"
    sha256               x86_64_linux:  "78832467961baa9a449b095d9bb0a9f015336e7286c7bc5cb37cfadadbaa29bf"
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
