class Appstream < Formula
  desc "Tools and libraries to work with AppStream metadata"
  homepage "https://www.freedesktop.org/wiki/Distributions/AppStream/"
  url "https://github.com/ximion/appstream/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "3289568eeaaa84365dcfc8a6be2b547a9abe05cec6d3f08b62f39e832a6e7cb9"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "bcacd6ca11d2eb261c94b41e89cc31f6d369476ead523edcd1b91927e1339d34"
    sha256 arm64_sequoia: "68e338200029613cda29a49fb75a3b8681f0d735ca0155275e548d3f2c75bcb9"
    sha256 arm64_sonoma:  "18c841eadb045644d94a58701efd8149f24cbbe2e25b9104258feb6f0885adc8"
    sha256 arm64_ventura: "9cad886c8567e76bd4c79f002239a790394444eef1fe8a04a2b94e1eb6dc2b67"
    sha256 sonoma:        "8ff67f71186f8f61acae079328fbee8babe750e6ba0a8b76d1e556d2622bd8da"
    sha256 ventura:       "ece9cdba8e6fe58b0b7f36cb292bbf294e3ba5d7b1b283ffd4c4c85300472bb5"
    sha256 arm64_linux:   "fef9a36faf13c12645617df56f1db917fbecdba948703bab0c2be619a09a8894"
    sha256 x86_64_linux:  "d2ae9f394287d84a1c08cf59146d4360ec7249e310bed7f8cc575410294dcfcd"
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
