class Appstream < Formula
  desc "Tools and libraries to work with AppStream metadata"
  homepage "https://www.freedesktop.org/wiki/Distributions/AppStream/"
  url "https://github.com/ximion/appstream/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "564ec87b16e9e4ee81fb021e612250fd27f3a3ecd31c209a5dd1ff59def3022d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "f2c581be46ed6b1247e389b64e1ad6362873ab8c03302cbf0dedc0120ab92299"
    sha256 arm64_sequoia: "796493bf50d9d0074104f9d531db5743535efd8331ca63e4f70cb1c5d4d37c91"
    sha256 arm64_sonoma:  "cfa7613cb47ceeb7db8eddddc3a53e390aa765a2b94d8122bbfb4f9cfe7e7e0b"
    sha256 sonoma:        "92b9ee15d004bc825753ae940b52a5ee6af25ff76baab576d7aacc5314515013"
    sha256 arm64_linux:   "4570742f348cdfc3f3308550fdd3a87997f7b32a5f1cce32bf514989bcae08b6"
    sha256 x86_64_linux:  "9739adf95825abbf49377ad78790e4878f40e871ead0f2f38dd547f021b97b9e"
  end

  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "libfyaml"
  depends_on "libxmlb"
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
      -Dbash-completion=false
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
