class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://wiki.gnome.org/Projects/Gjs"
  url "https://download.gnome.org/sources/gjs/1.48/gjs-1.48.7.tar.xz"
  sha256 "09dbf6e1a7f821df7c50098acc4489cfb4e943ec12f10258bb42b1a71061c36e"

  bottle do
    sha256 "c04df83feb487ff938c02af85b6e754758cf81f008ffa3b2a19db42772144d17" => :sierra
    sha256 "80de9e7cdb5d9ec254d1aa6b6ce8f242f849f84f9a945c50eb6646df97186476" => :el_capitan
    sha256 "5c11bd726a506c00dec1ead46cb702dfeeb826d39d89f68240c3066d5f77f93f" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gobject-introspection"
  depends_on "nspr"
  depends_on "readline"
  depends_on "gtk+3" => :recommended

  needs :cxx11

  resource "mozjs38" do
    url "https://archive.mozilla.org/pub/firefox/releases/38.8.0esr/source/firefox-38.8.0esr.source.tar.bz2"
    sha256 "9475adcee29d590383c4885bc5f958093791d1db4302d694a5d2766698f59982"
  end

  def install
    ENV.cxx11
    ENV["_MACOSX_DEPLOYMENT_TARGET"] = ENV["MACOSX_DEPLOYMENT_TARGET"]

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
