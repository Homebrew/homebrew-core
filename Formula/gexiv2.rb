class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  url "https://download.gnome.org/sources/gexiv2/0.12/gexiv2-0.12.3.tar.xz"
  sha256 "d23b7972a2fc6f840150bad1ed79c1cbec672951e180c1e1ec33ca6c730c59f3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d447c68667fbbe6c2fbc805d1a5500df516e349113b125a124b70ecce67320db"
    sha256 cellar: :any, big_sur:       "43b23687a2eda051948ca9cac9ec330fb1a68da5df5f1d902e19b6db4d13eef5"
    sha256 cellar: :any, catalina:      "2f66ad539032cd727aa9c61c61418aac3fea4488215d33d1b1360740527f73d1"
    sha256 cellar: :any, mojave:        "a5522b4ac7e5063ea54d66b16fd485f493680be08819fe789a53988b25346ecf"
    sha256               x86_64_linux:  "5d462920a64731dec1282ce9e56b28945ad233ea550bc826215c639be7fab49f"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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
