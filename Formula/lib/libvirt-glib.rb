class LibvirtGlib < Formula
  desc "Libvirt API for glib-based programs"
  homepage "https://libvirt.org/"
  url "https://download.libvirt.org/glib/libvirt-glib-5.0.0.tar.xz"
  sha256 "9bfec346382416a3575d87299bc641b2a464aa519fd9b1287e318aa43a2f3b8b"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url "https://download.libvirt.org/glib/"
    regex(/href=.*?libvirt-glib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "ba34897f21e90fc3c2e580b4b3a736ac40dde9df609b5e8bb650ed65d528bd41"
    sha256 arm64_sequoia: "2215ee81bf32c6dfb3e1091165cfcd1fd6130d190a368221567d26ac93a2d5a0"
    sha256 arm64_sonoma:  "6828ef86859fdc0166ae2f4265dcf3317ae70d7530b6f790f8fd2471a9991c7a"
    sha256 sonoma:        "c742a2ce49f8827cc5008a74871489df1a814af0672eab3e5d7b16ce78f155c3"
    sha256 arm64_linux:   "c89344493f689b1ed360b3fb32cec04f45b02fc5cd1acebee4f689a83a4a167a"
    sha256 x86_64_linux:  "9e5c86856ddc5d3b7cd2589a96289a4d8762095010a59ee6b413e50ca2c28752"
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libvirt"

  uses_from_macos "libxml2"

  def install
    system "meson", "setup", "builddir", "-Dintrospection=enabled", *std_meson_args
    system "meson", "compile", "-C", "builddir"
    system "meson", "install", "-C", "builddir"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <libvirt-gconfig/libvirt-gconfig.h>
      #include <libvirt-glib/libvirt-glib.h>
      #include <libvirt-gobject/libvirt-gobject.h>
      int main() {
        gvir_config_object_get_type();
        gvir_event_register();
        gvir_interface_get_type();
        return 0;
      }
    CPP
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
