class LibvirtGlib < Formula
  desc "Libvirt API for glib-based programs"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/glib/libvirt-glib-5.0.0.tar.xz"
  sha256 "9bfec346382416a3575d87299bc641b2a464aa519fd9b1287e318aa43a2f3b8b"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.libvirt.org/glib/"
    regex(/href=.*?libvirt-glib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "2c02eafd5e6cde6f4bc893e635687e3faeb75cd043ad4a779c6a0e3b8a52de67"
    sha256 arm64_sonoma:   "21ae7fd8db1783b08631d8e44055cd7cc60eb4e4bf688df5cdead90fb7fc841a"
    sha256 arm64_ventura:  "d43fac604883a2625dded58bcea30ac96f1631d534387ec02e990a385b70ee7d"
    sha256 arm64_monterey: "091f75018e1ae32fae44da96b038a24738168fc580266595e2e5cff1a14c94a6"
    sha256 sonoma:         "e2ac09fd3c7acd060404ef1ff2448762f37b10953bd7f0bf253c928ca3beecdc"
    sha256 ventura:        "f2bde563d71a665861a881e003ecb1f81160c638dfc4879182416f4ad8c5ec21"
    sha256 monterey:       "cc95cc480984e459d64e98ac4a34a28f098f01fdbe3a48eb4596ea0f04e18522"
    sha256 x86_64_linux:   "5929261ba67ca634fd615cb4f8c159017963a9b1a46bba55993b0b728593df70"
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libvirt"

  uses_from_macos "libxml2"

  def install
    system "meson", "setup", "builddir", *std_meson_args, "-Dintrospection=enabled"
    system "meson", "compile", "-C", "builddir"
    system "meson", "install", "-C", "builddir"
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
    libxml2 = if OS.mac?
      "#{MacOS.sdk_path}/usr/include/libxml2"
    else
      Formula["libxml2"].opt_include/"libxml2"
    end
    system ENV.cxx, "-std=c++11", "test.cpp",
                    "-I#{libxml2}",
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
