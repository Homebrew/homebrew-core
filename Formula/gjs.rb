class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://wiki.gnome.org/Projects/Gjs"
  url "https://download.gnome.org/sources/gjs/1.48/gjs-1.48.6.tar.xz"
  sha256 "e85f65ba4b38bf80b6174949dfe6fce89e88b8213bbdde4ac1fde473c08bd312"
  revision 1

  bottle do
    sha256 "0813457080cdf5730ac849f274b7ae2d166e9384d0f8806ce829021f2b865ec7" => :sierra
    sha256 "ca317b777dc73c3c25502c8c2c03b6c64ddd0328b9e825be9e3546ae88593b6b" => :el_capitan
    sha256 "b9e2728c2bbb68e02b1784d98878d6e71d4f0eba9d759a1b07996abc5f2c4e61" => :yosemite
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
