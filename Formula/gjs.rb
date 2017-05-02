class Gjs < Formula
  desc "Javascript Bindings for GNOME"
  homepage "https://wiki.gnome.org/Projects/Gjs"
  url "https://download.gnome.org/sources/gjs/1.48/gjs-1.48.2.tar.xz"
  sha256 "99c225ab2149bd31f7ac84d6ee1ea9ae843bf9a806ca853786d90e3182c4f4a1"

  bottle do
    sha256 "c6c3b714cc5db5e7936317519e746263ae574148f568b51cfb40edbc7a341af1" => :sierra
    sha256 "dd99869f90052c85f6cac41d073c802341de454235e588d2a1fcda697520306b" => :el_capitan
    sha256 "e112d2f46bfa1a6269ce3c0203ffa2576b426d3317dced1f16e7e029fc6a0879" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gobject-introspection"
  depends_on "nspr"
  depends_on "readline"
  depends_on "gtk+3" => :recommended

  needs :cxx11

  # patch submitted upstream: https://bugzilla.gnome.org/show_bug.cgi?id=780350
  patch :DATA

  resource "mozjs38" do
    url "https://archive.mozilla.org/pub/firefox/releases/38.8.0esr/source/firefox-38.8.0esr.source.tar.bz2"
    sha256 "9475adcee29d590383c4885bc5f958093791d1db4302d694a5d2766698f59982"
  end

  def install
    resource("mozjs38").stage do
      inreplace "config/rules.mk", "-install_name @executable_path/$(SHARED_LIBRARY) ", "-install_name #{lib}/$(SHARED_LIBRARY) "
      cd("js/src") do
        ENV["PYTHON"] = "python"
        inreplace "configure", "'-Wl,-executable_path,$(LIBXUL_DIST)/bin'", ""
        system "./configure", "--disable-debug",
                              "--disable-dependency-tracking",
                              "--disable-silent-rules",
                              "--prefix=#{prefix}",
                              "--with-system-nspr",
                              "--with-system-zlib",
                              "--with-system-icu",
                              "--enable-system-ffi",
                              "--enable-readline",
                              "--enable-shared-js",
                              "--enable-threadsafe"
        system "make"
        system "make", "install"
        rm Dir["#{bin}/*"]
      end
      mv "#{lib}/pkgconfig/js.pc", "#{lib}/pkgconfig/mozjs-38.pc"
      # headers were installed as softlinks, which is not acceptable
      cd(include.to_s) do
        `find . -type l`.chomp.split.each do |link|
          header = File.readlink(link)
          rm link
          cp header, link
        end
      end
      ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"
      # remove mozjs static lib
      rm "#{lib}/libjs_static.ajs"
    end
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-dbus-tests",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.js").write <<-EOS.undent
      #!/usr/bin/env gjs
      const GLib = imports.gi.GLib;
    EOS
    system "#{bin}/gjs", "test.js"
  end
end

__END__
diff --git a/gi/arg.cpp b/gi/arg.cpp
index 5502b00..aacc07d 100644
--- a/gi/arg.cpp
+++ b/gi/arg.cpp
@@ -37,6 +37,8 @@
 #include "gjs/byteArray.h"
 #include "gjs/jsapi-wrapper.h"
 #include <util/log.h>
+#include <cstdlib>
+#include <cmath>

 bool
 _gjs_flags_value_is_valid(JSContext   *context,
