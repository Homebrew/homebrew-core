class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  # release info on the website might lag behind, refer to gitlab tags for latest release info
  # see discussions in https://gitlab.gnome.org/GNOME/gexiv2/-/issues/77
  url "https://download.gnome.org/sources/gexiv2/0.14/gexiv2-0.14.2.tar.xz"
  sha256 "2a0c9cf48fbe8b3435008866ffd40b8eddb0667d2212b42396fdf688e93ce0be"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "21456f0d9f146e737dfcafcbca6bf138b4b154152a6f3273223a05fdff4b6cf7"
    sha256 cellar: :any, arm64_ventura:  "35d3a7abe2c441366641dfa49341e741a0850041cbb1498bf4a916fa2dbe8988"
    sha256 cellar: :any, arm64_monterey: "dd18a7a934b25bc03b0bab02dacaca8d6bda12a934ea3fb566a6dd2cd0f840b3"
    sha256 cellar: :any, arm64_big_sur:  "1e6b309ab6e74bbe315a19db19252ed5e6837ffce275025ca2564fff12db6f66"
    sha256 cellar: :any, sonoma:         "c595d87216be6c429c41c952c5ab529864d2be75fbd6e665cc1f4ac93ab7ca70"
    sha256 cellar: :any, ventura:        "56c24c526d715211d5e4301e56b7aeb22b0f8ab32f0d613c76fadae27839ab18"
    sha256 cellar: :any, monterey:       "0ba2f996b0423efb0dbad102ffbb3cebb530f247927da34f3d7864ed4d5de6da"
    sha256 cellar: :any, big_sur:        "278657972231bf1cf85ee3027fde22c509377980bf9552c3d98fc5a45b47143e"
    sha256               x86_64_linux:   "073c9867aa36797320047535854b00c861eaa3b9f04755bf1f8196f9e773cf4b"
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
