class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://wiki.gnome.org/Projects/Gjs"
  url "https://download.gnome.org/sources/gjs/1.52/gjs-1.52.3.tar.xz"
  sha256 "ce21d8a83f6077b011b8834c4936281be65b2b62387f0745c3eb9adf780996fc"

  bottle do
    sha256 "f49db17dd1f920fb8325f35799ba501777201e7be20bd511ee4fd3e715447a32" => :high_sierra
    sha256 "5e0fde236bc3e0bdeb5a4c2ed2898d07e1dccc504639e73754cc294c6cf72bf5" => :sierra
    sha256 "f383578fa258ff336c1045f3fb9dc752fa6d74c0f9e6650554f853aa585409a8" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf@2.13" => :build
  depends_on "gobject-introspection"
  depends_on "nspr"
  depends_on "readline"
  depends_on "gtk+3" => :recommended

  needs :cxx11

  resource "mozjs52" do
    url "https://archive.mozilla.org/pub/firefox/releases/52.3.0esr/source/firefox-52.3.0esr.source.tar.xz"
    sha256 "c16bc86d6cb8c2199ed1435ab80a9ae65f9324c820ea0eeb38bf89a97d253b5b"
  end

  def install
    ENV.cxx11
    ENV["_MACOSX_DEPLOYMENT_TARGET"] = ENV["MACOSX_DEPLOYMENT_TARGET"]

    resource("mozjs52").stage do
      inreplace "config/rules.mk", "-install_name $(_LOADER_PATH)/$(SHARED_LIBRARY) ", "-install_name #{lib}/$(SHARED_LIBRARY) "
      inreplace "old-configure", "-Wl,-executable_path,${DIST}/bin", ""
      mkdir("build") do
        ENV["PYTHON"] = "python"
        system "../js/src/configure", "--prefix=#{prefix}",
                              "--with-system-nspr",
                              "--with-system-zlib",
                              "--with-system-icu",
                              "--enable-readline",
                              "--enable-shared-js",
                              "--with-pthreads",
                              "--enable-optimize",
                              "--enable-pie",
                              "--enable-release",
                              "--without-intl-api"
        system "make"
        system "make", "install"
        lib.install "./mozglue/build/libmozglue.dylib"
        rm Dir["#{bin}/*"]
      end
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
                          "--disable-profiler",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.js").write <<~EOS
      #!/usr/bin/env gjs
      const GLib = imports.gi.GLib;
    EOS
    system "#{bin}/gjs", "test.js"
  end
end
