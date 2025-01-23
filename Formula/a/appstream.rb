class Appstream < Formula
  desc "Tools and libraries to work with AppStream metadata"
  homepage "https://www.freedesktop.org/wiki/Distributions/AppStream/"
  url "https://github.com/ximion/appstream/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "dff6efa67d9ea4797870d70e3370b9e3fa66ce3c749aba68e6b10222473463cf"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "de62d82451bf33ab222ab41e080b269ccccbdf783b937bd12dae73d58eb38bca"
    sha256 arm64_sonoma:  "e75acaef6c396718c861b43aabd22f0c2c94ba48d255f11ce09e74bd74f91611"
    sha256 arm64_ventura: "b1b77b98da40f286a86224a0b1558883b18da353300aa9a3f45d8fa66ac4e6c9"
    sha256 sonoma:        "53a3c53f4b245c5a0a0272d50b2b0299a5192c31f764e4754f964023582404f6"
    sha256 ventura:       "7988e078155c5dda38b04fe087175a424cde46ee55cd1aa475b0f561588fa536"
    sha256 x86_64_linux:  "7c5f10150e811806ef75adff56a94eabae08eb4c37b5afb22b81374c57ceb63a"
  end

  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "libxmlb"
  depends_on "libyaml"
  depends_on "zstd"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gettext" => :build
    depends_on "gperf" => :build
    depends_on "systemd"
  end

  # fix macos build, upstream PR ref, https://github.com/ximion/appstream/pull/556
  patch do
    url "https://github.com/ximion/appstream/commit/06eeffe7eba5c4e82a1dd548e100c6fe4f71b413.patch?full_index=1"
    sha256 "d0ad5853d451eb073fc64bd3e9e58e81182f4142220e0f413794752cda235d28"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    inreplace "meson.build", "/usr/include", prefix.to_s

    args = %w[
      -Dstemming=false
      -Dvapi=true
      -Dgir=true
      -Ddocs=false
      -Dapidocs=false
      -Dinstall-docs=false
    ]

    args << "-Dsystemd=false" if OS.mac?

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"appdata.xml").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <component type="desktop-application">
        <id>org.test.test-app</id>
        <name>Test App</name>
      </component>
    XML
    (testpath/"test.c").write <<~C
      #include "appstream.h"

      int main(int argc, char *argv[]) {
        GFile *appdata_file;
        char *appdata_uri;
        AsMetadata *metadata;
        GError *error = NULL;
        char *resource_path = "#{testpath}/appdata.xml";
        appdata_file = g_file_new_for_path (resource_path);
        metadata = as_metadata_new ();
        if (!as_metadata_parse_file (metadata, appdata_file, AS_FORMAT_KIND_UNKNOWN, &error)) {
          g_error ("Could not parse metadata file: %s", error->message);
          g_clear_error (&error);
        }
      }
    C
    flags = shell_output("pkg-config --cflags --libs appstream").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    assert_match version.to_s, shell_output("#{bin}/appstreamcli --version")
  end
end
