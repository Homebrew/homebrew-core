class Appstream < Formula
  desc "Tools and libraries to work with AppStream metadata"
  homepage "https://www.freedesktop.org/wiki/Distributions/AppStream/"
  url "https://github.com/ximion/appstream/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "dd7222519b5d855124fa803ce82a7cbf090ac6b2e44a5bc515e729b1f20a63ae"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia:  "b5db78dda7f5e0a8f54bc2ee78c275b0cf8bd56a8fe3b29022a80133a2a8c359"
    sha256 arm64_sonoma:   "1216f3383a370abd9d48a4fd093d49f3b72bc552f7c4e680cdc093473da22a44"
    sha256 arm64_ventura:  "5ff6cd337a86f14fb4aee3c30bb73cd5c697730dbb1465d52c49e9f1783ff12f"
    sha256 arm64_monterey: "a7dac1620d0dd18128b5a2404aef78b76577ef75937a9f35c6645a05fb17870d"
    sha256 sonoma:         "246da0463c09a29db3b7c90f3fe1727d9d533e1d8a1cb5483fd1868100eae6cb"
    sha256 ventura:        "96edae4d536442fc486fba42b6083f124fe26fa172082845fb74ae5d2244f282"
    sha256 monterey:       "f3c697a57914dde1489b1328fb653d46c46cf4a8d6f437d28d90c80632aa200f"
    sha256 x86_64_linux:   "8a7343939bd883cc71503d5f47a738480e4aad4e0ffc75d37288033e167b6bc3"
  end

  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
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
