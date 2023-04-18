class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  url "https://download.gnome.org/sources/gexiv2/0.14/gexiv2-0.14.0.tar.xz"
  sha256 "e58279a6ff20b6f64fa499615da5e9b57cf65ba7850b72fafdf17221a9d6d69e"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "4acc296cbfbf2c39288b0bb622910e5e2f03ca0ad68e5d5f3af4fb503ae5bf68"
    sha256 cellar: :any, arm64_monterey: "b6300eb15acf22cac3466956e449484911db0f9b67427829504216dcf39514f0"
    sha256 cellar: :any, arm64_big_sur:  "a0506d0841fd0ce639b3a25d6f4fb4f822c9380cb79cc144b91f007249abe702"
    sha256 cellar: :any, ventura:        "f5329234f64886acb9aad2e3fdbf01b774c6ae2b7a9f18cf88cfa3a57ad721da"
    sha256 cellar: :any, monterey:       "5a8be246495cd20807578417ecbd8d9d758e234f1bd441e23acc1f52606eb2b4"
    sha256 cellar: :any, big_sur:        "0a57239cb2d1492d0769602ce43b1b847bf0609443fe8666cf7ebd1e64bdc779"
    sha256               x86_64_linux:   "d23162496ce910b7d2f4cd2f1e5721b75cd4346e5f6c77235ae549820a338164"
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
    site_packages = prefix/Language::Python.site_packages("python3.11")

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
