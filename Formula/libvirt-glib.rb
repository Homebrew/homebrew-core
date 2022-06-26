class LibvirtGlib < Formula
  desc "Libvirt API for glib-based programs"
  homepage "https://libvirt.org/"
  url "https://libvirt.org/sources/glib/libvirt-glib-4.0.0.tar.xz"
  sha256 "8423f7069daa476307321d1c11e2ecc285340cd32ca9fc05207762843edeacbd"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://libvirt.org/sources/glib/"
    regex(/href=.*?libvirt-glib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "e8bfac0fafee87488e06debd73ebcc991f1d628afa2106b32161da94a41faa22"
    sha256 arm64_big_sur:  "4d4918afe72309394ab15e98a5b15cf5c77e8027b20bc7bc7c1f0fb7524dbf78"
    sha256 monterey:       "7c4c421cc28957cbb15e3e4335908cda7f92f720dee6b749d8a224b141633f48"
    sha256 big_sur:        "9695bd9cca917eabee5eeaa038470e0a42c13767c420357ece93519958aa7653"
    sha256 catalina:       "101d1a4bf6b4c45b49261fc97ddfb73d34a30511f6a24fc8f31c48caff8e14f4"
    sha256 mojave:         "9a3967ba636f27cd1c923603e1df533b5edc7a7d5c90b089bf0154cd7b408b7f"
    sha256 x86_64_linux:   "dca22d86f5c9e75e1abd763a252c0468da812032f80fae12514f57bb33023ffb"
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
    cd "builddir" do
      system "meson", "compile"
      system "meson", "install"
    end
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
    system ENV.cc, "test.cpp",
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
