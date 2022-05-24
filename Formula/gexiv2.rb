class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  url "https://download.gnome.org/sources/gexiv2/0.14/gexiv2-0.14.0.tar.xz"
  sha256 "e58279a6ff20b6f64fa499615da5e9b57cf65ba7850b72fafdf17221a9d6d69e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "031ba5ff86ee4d9c3eff73caa1810b198919d6202671c565e3542c4825d50c55"
    sha256 cellar: :any, monterey:      "c6c54be9582a1f39bf560baf839c3949fd6e12c15336763ca6ae8455e754b2cd"
    sha256 cellar: :any, big_sur:       "998ef3640d04fa7e5480d8a5ddb476c5a8bde6120b234854c315ebdceccc5d78"
    sha256 cellar: :any, catalina:      "9f00ba7ae2da026d10e53c5ee3439a35ae8b2d9e6ec94c13efd16d756844b4f5"
    sha256 cellar: :any, mojave:        "a5dbf41078b0b748aa002e07b11d4063e6d2079a1740534322102689d84344d5"
    sha256               x86_64_linux:  "3d95b43c323ebc976f94527574ee81bbe061e632cd37789e0c9a64009d3fd3df"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "pygobject3" => :build
  depends_on "python@3.9" => :build
  depends_on "vala" => :build
  depends_on "exiv2"
  depends_on "glib"

  def install
    pyver = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"

    mkdir "build" do
      system "meson", *std_meson_args, "-Dpython3_girdir=#{lib}/python#{pyver}/site-packages/gi/overrides", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gexiv2/gexiv2.h>
      int main() {
        GExiv2Metadata *metadata = gexiv2_metadata_new();
        return 0;
      }
    EOS

    flags = [
      "-I#{HOMEBREW_PREFIX}/include/glib-2.0",
      "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include",
      "-L#{lib}",
      "-lgexiv2",
    ]

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
