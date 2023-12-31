class Appstream < Formula
  desc "Tools and libraries to work with AppStream metadata"
  homepage "https://www.freedesktop.org/wiki/Distributions/AppStream/"
  url "https://github.com/ximion/appstream/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "3a6877c887627aed515e9802f63ac7bd83fffab4c2cad33c809c692c4bd8da48"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "ab51ea38274287d57b8185a1f65036bcd398fbcf7ac578332fdda27a0f880007"
    sha256 arm64_ventura:  "bc61a9403a260d44664b5997337ee600a194a25c918d22683a02b3b72723fd9c"
    sha256 arm64_monterey: "d6f9ade136e25d9a5862d2df5b808d97de6b800bd6179d2b43c3077f173929e5"
    sha256 sonoma:         "5721b6b4672087f747066f7c3552311e819474a79d8cfebeeadcf8f194801f8a"
    sha256 ventura:        "b69aca4ede70aaa6abdc93898972a05475e6756458018fc0857777ee7b5c9dbf"
    sha256 monterey:       "afedea075c65f159a0d558fde1d9cabe625f7c8fa3dc2b7ceed875209e951bd1"
    sha256 x86_64_linux:   "5f70d1b317c34e74ee6446a5958a2a3c78b828ee61a79251ce5c5183e6fd659c"
  end

  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "libxmlb"
  depends_on "libyaml"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "libxml2"

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
    (testpath/"appdata.xml").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <component type="desktop-application">
        <id>org.test.test-app</id>
        <name>Test App</name>
      </component>
    EOS
    (testpath/"test.c").write <<~EOS
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
    EOS
    flags = shell_output("pkg-config --cflags --libs appstream").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    assert_match version.to_s, shell_output("#{bin}/appstreamcli --version")
  end
end
