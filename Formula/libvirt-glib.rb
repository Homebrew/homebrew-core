class LibvirtGlib < Formula
  desc "Libvirt API for glib-based programs"
  homepage "https://libvirt.org/"
  url "https://libvirt.org/sources/glib/libvirt-glib-3.0.0.tar.gz"
  sha256 "7fff8ca9a2b723dbfd04223b1c7624251c8bf79eb57ec27362a7301b2dd9ebfe"
  license "LGPL-2.1"

  bottle do
    sha256 "0e4ef4273857818f627595c15dbda1e69ef71a71ec4aaed88c33a6af96e65a80" => :catalina
    sha256 "bfd1b4197f3069d72dd8da66002ee3f138f165eb9956e217ee7a36bd8cea1e15" => :mojave
    sha256 "dde218b4644a43fd7fe9b47bd62e0d2ec0b7f52a4e6d68ca5413c3fd04da5800" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build

  depends_on "gettext"
  depends_on "glib"
  depends_on "libvirt"

  def install
    # macOS ld does not support linker option: --version-script
    # https://bugzilla.redhat.com/show_bug.cgi?id=1304981
    inreplace "libvirt-gconfig/Makefile.in", /^.*-Wl,--version-script=.*$\n/, ""
    inreplace "libvirt-glib/Makefile.in",    /^.*-Wl,--version-script=.*$\n/, ""
    inreplace "libvirt-gobject/Makefile.in", /^.*-Wl,--version-script=.*$\n/, ""

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-introspection
      --prefix=#{prefix}
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libvirt-gconfig/libvirt-gconfig.h>
      #include <libvirt-glib/libvirt-glib.h>
      #include <libvirt-gobject/libvirt-gobject.h>
      int main() {
        gvir_config_object_get_type();
        gvir_event_register();
        gvir_interface_get_type();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp",
                   "-I#{MacOS.sdk_path}/usr/include/libxml2",
                   "-I#{Formula["glib"].include}/glib-2.0",
                   "-I#{Formula["glib"].lib}/glib-2.0/include",
                   "-I#{include}/libvirt-gconfig-1.0",
                   "-I#{include}/libvirt-glib-1.0",
                   "-I#{include}/libvirt-gobject-1.0",
                   "-L#{lib}",
                   "-lvirt-gconfig-1.0",
                   "-lvirt-glib-1.0",
                   "-lvirt-gobject-1.0",
                   "-o", "test"
    system "./test"
  end
end
