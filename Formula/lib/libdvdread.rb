class Libdvdread < Formula
  desc "C library for reading DVD-video images"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  url "https://download.videolan.org/pub/videolan/libdvdread/7.0.1/libdvdread-7.0.1.tar.xz"
  sha256 "2e3e04a305c15c3963aa03ae1b9a83c1d239880003fcf3dde986d3943355d407"
  license "GPL-2.0-or-later"
  head "https://code.videolan.org/videolan/libdvdread.git", branch: "master"

  livecheck do
    url "https://download.videolan.org/pub/videolan/libdvdread/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "54d1f61fbf8b6c888f2c4149b2bcdfcbcef2c493c70db26495ab42498910e608"
    sha256 cellar: :any,                 arm64_sequoia: "25f754da405f2c02ae5a9c14b5ad47ce236887761b4be028c0deae2a8093a454"
    sha256 cellar: :any,                 arm64_sonoma:  "8abef1c1523b58c5e189822cac176350d646b2c1437aed944e5c45c24782d763"
    sha256 cellar: :any,                 sonoma:        "75e27f2e60a264f7b9bc784c80232372f8fea26c1aa131d885b79a5b425b152b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a6f373273280da9caf7062165ac7c61f1cf7cf982dd84ee38262bda730e8558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db15d6c2ddc18ffbc1ebfe27ea94320e452a43b9a3ea44709791077c5a237693"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test
  depends_on "libdvdcss"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <dvdread/version.h>
      #include <stdio.h>

      int main(int argc, char** argv) {
        printf("%s\\n", DVDREAD_VERSION_STRING);
        return 0;
      }
    C

    pkg_config_flags = shell_output("pkgconf --cflags --libs dvdread").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
