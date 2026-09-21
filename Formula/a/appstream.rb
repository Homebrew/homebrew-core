class Appstream < Formula
  desc "Tools and libraries to work with AppStream metadata"
  homepage "https://www.freedesktop.org/wiki/Distributions/AppStream/"
  url "https://github.com/ximion/appstream/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "02f723cb1afa372d434896e138503163a44ad49e4a813d0d30713fc38ccb8d0c"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_golden_gate: "ce221f500feb9906108821e6efdbd1185ec559bdcb0de9210abe80fa1e61257f"
    sha256 arm64_tahoe:       "e6b87c9e02342b8ccd9a395d4f445ced6111339e03a52d5a7b4d861a440b5930"
    sha256 arm64_sequoia:     "604eafd3c96174850663c242804c118d6bc7311a2a9cef8838ceccfe8ff241a3"
    sha256 arm64_sonoma:      "1524097ba8b03c845424486a93edb3a87572ff033ebc5f8d5b355c75a76924cc"
    sha256 arm64_linux:       "a6995700d66b2c34cf2830b45cc0385daf371693fa77802a25b6add07eddbe7f"
    sha256 x86_64_linux:      "9338282f7cf8aa877fe0ede9aa968cc7b295bdffb023e875e1402433dc4bdcf2"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
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
    depends_on "wayland"
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
      -Ddisplay-detection=auto
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
