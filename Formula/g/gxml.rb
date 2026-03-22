class Gxml < Formula
  desc "GObject-based XML DOM API"
  homepage "https://wiki.gnome.org/GXml"
  url "https://gitlab.gnome.org/GNOME/gxml/-/archive/0.20.4/gxml-0.20.4.tar.bz2"
  sha256 "d8d8b16ff701d0c5ff04b337b246880ec4523abfe897a1f77acdf7d73fb14b84"
  license "LGPL-2.1-or-later"
  revision 2

  bottle do
    sha256 arm64_tahoe:   "a3da5e42590fe64560597a9dd87d4ef7b99a7fab333a8ce2b1b307709892eab6"
    sha256 arm64_sequoia: "371bfb0dcf652b8f7fa6f79783ca427c1228fba85314a430397080ba47aebe2a"
    sha256 arm64_sonoma:  "440e8583de82f846393564e4e505b952250609103377dce30cc4141cdb9a5afd"
    sha256 sonoma:        "f26bdae2e98a12878bf0266f81ead6d0d35049aac22f6d7e998dec91f4cbe1ab"
    sha256 arm64_linux:   "a005ed52b097ee095f4ec60799afa0428ddc924a84715522d5787e5430f50448"
    sha256 x86_64_linux:  "34f65c1d4ae3dedf814cf963ac7bcc5619bd80285d22f151a679cc1eb24e6e4b"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "libgee"
  depends_on "libxml2"

  on_macos do
    depends_on "gettext"
  end

  # fix version comparison in gxml.pc.in, upstream pr ref, https://gitlab.gnome.org/GNOME/gxml/-/merge_requests/28
  patch do
    url "https://gitlab.gnome.org/GNOME/gxml/-/commit/6551103abd5143e51814ec1dce9b36bb9a46e09f.diff"
    sha256 "b87f585ab782b2ff4f024c45c9a90791c2023e3703756f2eb799591e7978e640"
  end

  def install
    system "meson", "setup", "build", "-Dintrospection=true", "-Ddocs=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gxml/gxml.h>

      int main(int argc, char *argv[]) {
        GType type = gxml_document_get_type();
        return 0;
      }
    C
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libxml2"].opt_lib/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs libxml-2.0 gxml-0.20").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
