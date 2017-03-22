class Gjs < Formula
  desc "Javascript Bindings for GNOME"
  homepage "https://wiki.gnome.org/Projects/Gjs"
  url "https://download.gnome.org/sources/gjs/1.48/gjs-1.48.0.tar.xz"
  sha256 "ed7db93e12709fe43b2fbe1e157331a0b1dcf3e0d19b81ccebd2d96bfcbe9525"

  bottle do
    sha256 "9a90cec9628aa4c648a3071eb43e0291c30bee3ad1f53b3907e8358395ef9e80" => :sierra
    sha256 "ef052db92391f3ccd9016f8f90b6b29ac2336884f2334d20e35e74eb9f6f6704" => :el_capitan
    sha256 "0c625e0ea598dcfc143f710de929683cac1aeded17d425b7dba63263a51ba14c" => :yosemite
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

