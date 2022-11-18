class LibvirtGlib < Formula
  desc "Libvirt API for glib-based programs"
  homepage "https://libvirt.org/"
  url "https://libvirt.org/sources/glib/libvirt-glib-4.0.0.tar.xz"
  sha256 "8423f7069daa476307321d1c11e2ecc285340cd32ca9fc05207762843edeacbd"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url "https://libvirt.org/sources/glib/"
    regex(/href=.*?libvirt-glib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "6b0abd52b2307364ce3fe0eab6634fbf90321f368ec3011b6e5110b76d295251"
    sha256 arm64_monterey: "9281991a193059f2d8a39184c823652dc025b8f9ba9c888aba64b5b66d948e9b"
    sha256 arm64_big_sur:  "dabfb25d593762d34de972fa15e7ef7c6a972c4790c9fb617c22d8dc4645fd3f"
    sha256 ventura:        "f3836928dbd5c4d6102bb5be4e2676f2f0b0d2d10255d4144cc6df0ea78649c2"
    sha256 monterey:       "f4a3e22facc0423d19b0a6adfcfa8bd678cf568b77d01f561dcb0e2c2341477b"
    sha256 big_sur:        "fcd83bb1020ffbda0c8fd75b05e844708f0b08fe3068796af7270a0107e6f342"
    sha256 catalina:       "4cffd32386653646d48037290a8c7d804a0ba75b1684312e8a2dc9d8f3ae42cb"
    sha256 x86_64_linux:   "9ba421c50085712b450e1986d20e22b09b334548c70257cd83ca9afda92b07ed"
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
