class LibvirtGlib < Formula
  desc "Libvirt API for glib-based programs"
  homepage "https://libvirt.org/"
  url "https://libvirt.org/sources/glib/libvirt-glib-2.0.0.tar.gz"
  sha256 "94e8c410c67501303d3b32ca8ce2c36edf898511ec4de9b7f29cd35d274b3d6a"
  revision 1

  bottle do
    sha256 "7b6665ce900145b71afcc3e77821b8292072de84662a8e0588ff9c416adce946" => :mojave
    sha256 "49573b3aa06fbc8ccf8ef3ebf40ffc6550b74d3592b58e336d11e3dc0d654a60" => :high_sierra
    sha256 "c98664ee49b401f61b05984f7bc5a992cb91aeecd744beae3bf5f38857b42af8" => :sierra
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
