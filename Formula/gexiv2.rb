class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  url "https://download.gnome.org/sources/gexiv2/0.12/gexiv2-0.12.2.tar.xz"
  sha256 "2322b552aca330eef79724a699c51a302345d5e074738578b398b7f2ff97944c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "34a026a5141ad0f252332d7e7c2a594f9436673068e6cc555eff0c0e537f750d"
    sha256 cellar: :any, big_sur:       "281c26fef197eba6584e3250aeb131c0ab5daf8afbdc1d702de71ba1e664ccf3"
    sha256 cellar: :any, catalina:      "b96f01c0d637c9b4e16bf0f4d3dc4d072d0d672396152893b5afcbc0ae60cd3a"
    sha256 cellar: :any, mojave:        "35e12c640ea61bd4659a86afb45e03efa8f81bfb46cb3a5119cb34f445f2dff2"
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
