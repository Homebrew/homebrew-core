class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  url "https://download.gnome.org/sources/gexiv2/0.14/gexiv2-0.14.0.tar.xz"
  sha256 "e58279a6ff20b6f64fa499615da5e9b57cf65ba7850b72fafdf17221a9d6d69e"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "12296a8bf2d516e6d586c3a06a5ea85310441bf110311834b4654db0b2b18460"
    sha256 cellar: :any, arm64_big_sur:  "f974a143db8c40d1917ab50cc52e35329d50c73594205d2c0e1cc393bb573cc4"
    sha256 cellar: :any, monterey:       "5baf8a5d48b15b71bd803a236189448441dda41addb39ec80380f3a5eba8ab4d"
    sha256 cellar: :any, big_sur:        "35775760fc0e8bc389c960183d9202ae870e0987141020545d20d4b98205fd4f"
    sha256 cellar: :any, catalina:       "87bc94b311f753a585dcd4703fe2c900c590daba7993298f2c9c9dd0c3ecfdbf"
    sha256               x86_64_linux:   "480cdfc4363ba55560479ce216bd289326cc40833770757b80fbc42529633608"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "pygobject3" => :build
  depends_on "python@3.10" => :build
  depends_on "vala" => :build
  depends_on "exiv2"
  depends_on "glib"

  def install
    site_packages = prefix/Language::Python.site_packages("python3.10")

    system "meson", *std_meson_args, "build", "-Dpython3_girdir=#{site_packages}/gi/overrides"
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
