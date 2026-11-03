class Libgovirt < Formula
  desc "GObject-based library to access oVirt REST API"
  homepage "https://gitlab.gnome.org/GNOME/libgovirt"
  url "https://download.gnome.org/sources/libgovirt/0.3/libgovirt-0.3.11.tar.xz"
  sha256 "081c1fb5091cb8a1660ea9c152b689de9ba191d10a1109df503f5754f318af7e"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  # libgovirt doesn't seem to follow the typical GNOME version scheme, so we
  # provide a regex to disable the `Gnome` strategy's version filtering.
  livecheck do
    url :stable
    regex(/libgovirt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "91db71b22fa5d555412e8b53caea35d9344fb8a489e86084f0ad026141317ade"
    sha256 cellar: :any, arm64_tahoe:       "55bbab848a8611ad1243add6a52d72a72e3df60633e12cf3b9afa6fae3b5c13b"
    sha256 cellar: :any, arm64_sequoia:     "cce3ae0c65ce6feb8cc6271b67c115e214648570f76991628e72afd78d528d0f"
    sha256 cellar: :any, arm64_linux:       "72465a6fa26228e2ba11942caf244557e901d5525fbdbd1d3ae1be8c06dda846"
    sha256 cellar: :any, x86_64_linux:      "7bb50bb3b6719ee8ab1bbc7033b891d7f21f467a7141c3f7aef6a557dac057ec"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "glib"
  depends_on "librest"
  depends_on "libsoup"

  deny_network_access!

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # The library only talks to an oVirt engine, which cannot be reached from
    # the Homebrew test sandbox, so feed a REST XML node straight into the
    # public API instead. This exercises type registration, the XML parsing
    # of a VM and its display, and the error path for invalid XML.
    (testpath/"test.c").write <<~'C'
      #include <govirt/govirt.h>
      #include <rest/rest-xml-parser.h>

      int main(void) {
        GError *error = NULL;
        OvirtVm *vm;
        OvirtVmDisplay *display = NULL;
        RestXmlNode *node;
        RestXmlParser *parser = rest_xml_parser_new();
        char *name = NULL;
        char *address = NULL;
        guint secure_port = 0;
        int state = -1;
        int display_type = -1;

        /* A VM without the mandatory id/href attributes must be rejected. */
        node = rest_xml_parser_parse_from_data(parser,
            "<vm><display><type>spice</type></display></vm>", -1);
        g_assert_nonnull(node);
        vm = OVIRT_VM(g_initable_new(OVIRT_TYPE_VM, NULL, &error, "xml-node", node, NULL));
        rest_xml_node_unref(node);
        g_assert_null(vm);
        g_assert_error(error, OVIRT_ERROR, OVIRT_ERROR_PARSING_FAILED);
        g_clear_error(&error);

        node = rest_xml_parser_parse_from_data(parser,
            "<vm href=\"/ovirt-engine/api/vms/1234\" id=\"1234\">"
            "<name>testvm</name>"
            "<status>up</status>"
            "<display>"
            "<type>spice</type>"
            "<address>127.0.0.1</address>"
            "<secure_port>5900</secure_port>"
            "<monitors>2</monitors>"
            "</display>"
            "</vm>", -1);
        g_assert_nonnull(node);

        vm = OVIRT_VM(g_initable_new(OVIRT_TYPE_VM, NULL, &error, "xml-node", node, NULL));
        rest_xml_node_unref(node);
        g_assert_no_error(error);
        g_assert_nonnull(vm);

        g_object_get(vm, "name", &name, "state", &state, "display", &display, NULL);
        g_assert_cmpstr(name, ==, "testvm");
        g_assert_cmpint(state, ==, OVIRT_VM_STATE_UP);
        g_assert_nonnull(display);

        g_object_get(display,
                     "type", &display_type,
                     "address", &address,
                     "secure-port", &secure_port,
                     NULL);
        g_assert_cmpint(display_type, ==, OVIRT_VM_DISPLAY_SPICE);
        g_assert_cmpstr(address, ==, "127.0.0.1");
        g_assert_cmpuint(secure_port, ==, 5900);

        g_free(name);
        g_free(address);
        g_clear_object(&display);
        g_object_unref(vm);
        g_object_unref(parser);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs govirt-1.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
