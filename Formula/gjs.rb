class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://wiki.gnome.org/Projects/Gjs"
  url "https://download.gnome.org/sources/gjs/1.52/gjs-1.52.1.tar.xz"
  sha256 "a8fc9a4991e2b5611d54029b623de2a62522342766e4011504f4f538764735e8"

  bottle do
    sha256 "7a496f22e6d162b77b406f4552d9ff4851965d91696e5e620dfb0cf8afedb031" => :high_sierra
    sha256 "54362b4cfee450f9429edc50043afb5e7e204714abf5165bee43032130f59d8f" => :sierra
    sha256 "b84679b610fba677288fa7773b950fbd8d81245cccb3c8e1bd0acd90bb875245" => :el_capitan
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
