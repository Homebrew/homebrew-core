class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  url "https://download.gnome.org/sources/gexiv2/0.14/gexiv2-0.14.1.tar.xz"
  sha256 "ec3ee3ec3860b9c78958a55da89cf76ae2305848e12f41945b7b52124d8f6cf9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "0ad8f1ab36aba81270108f1e0efd0f1cbf52071e8728dfd3c84e4ff6d290ec6f"
    sha256 cellar: :any, arm64_monterey: "4956e81fab4afe0d14d499c5ff1b9426f98a8333e5f3a53851f09101d55c845a"
    sha256 cellar: :any, arm64_big_sur:  "a6d044f982057d83aa4d897ced3b05df07235ab0d588a5b828806df89a1b5eea"
    sha256 cellar: :any, ventura:        "a3258b5851f29bfe3fe07a6bdc411da5f82e662f9bd11e4d55f2f39dd747490f"
    sha256 cellar: :any, monterey:       "c0f322b7db018e2d59cc805b9c324310f9a9463edee5cf48f23d8ae114c8f5d3"
    sha256 cellar: :any, big_sur:        "95ac2d7d2cf9412107765bd9b932fc8cbe54b21d01569423fb450b3d50e7ad01"
    sha256               x86_64_linux:   "328c1222b8af6349b919fc13253e390cf3b8ee51aeb37d7db52e8a53094e2e17"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "pygobject3" => :build
  depends_on "python@3.11" => :build
  depends_on "vala" => :build
  depends_on "exiv2"
  depends_on "glib"

  def install
    # Update to use c++17 when `exiv2` is updated to use c++17
    system "meson", *std_meson_args, "build", "-Dcpp_std=c++11"
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gexiv2/gexiv2.h>
      int main() {
        GExiv2Metadata *metadata = gexiv2_metadata_new();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test",
                   "-I#{HOMEBREW_PREFIX}/include/glib-2.0",
                   "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include",
                   "-L#{lib}",
                   "-lgexiv2"
    system "./test"
  end
end
