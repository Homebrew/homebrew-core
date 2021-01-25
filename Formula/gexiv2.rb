class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  url "https://download.gnome.org/sources/gexiv2/0.12/gexiv2-0.12.1.tar.xz"
  sha256 "8aeafd59653ea88f6b78cb03780ee9fd61a2f993070c5f0d0976bed93ac2bd77"
  license "GPL-2.0"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "c70dc1804031fb8c387dc3eff59274de4fdd85152df44f42001c630302080ea7" => :big_sur
    sha256 "9ebb451be639c6e3557c4113dc999ab3a0ef6c0f9f2ab508a6eb5197da40e2c7" => :catalina
    sha256 "87d16bcad50a98b318106735fb10ed2652d8cab8768f2e9a5fb8690690d656d5" => :mojave
    sha256 "6fdb45c5dec3259a2f178fdd3baee874d3b6db477ab2067d89635632900742a8" => :high_sierra
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
