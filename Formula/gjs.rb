class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://wiki.gnome.org/Projects/Gjs"
  url "https://download.gnome.org/sources/gjs/1.48/gjs-1.48.3.tar.xz"
  sha256 "669b7d78ad98390a762eec50d7cc637e25f196d986c0200d9f1c3a0e0cd90f33"

  bottle do
    sha256 "d482b9aab25ce9099e3205a438507d34a31b1c252140d034b53e015bd7490326" => :sierra
    sha256 "7bec881a9a2f7996eee7922801f3f00cbf7db8b22ed64b7573e1cc209f6daf59" => :el_capitan
    sha256 "ac1d5467c00620cda2bd1cde60d663c7e275298fb4b229108c14ea2cd7cf5255" => :yosemite
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
