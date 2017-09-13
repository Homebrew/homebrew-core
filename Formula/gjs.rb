class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://wiki.gnome.org/Projects/Gjs"
  url "https://download.gnome.org/sources/gjs/1.50/gjs-1.50.0.tar.xz"
  sha256 "2d529d315fc926995c5174d0ac45dacd604e52b9213ba3c4cd77f30bc4aec945"

  bottle do
    sha256 "c04df83feb487ff938c02af85b6e754758cf81f008ffa3b2a19db42772144d17" => :sierra
    sha256 "80de9e7cdb5d9ec254d1aa6b6ce8f242f849f84f9a945c50eb6646df97186476" => :el_capitan
    sha256 "5c11bd726a506c00dec1ead46cb702dfeeb826d39d89f68240c3066d5f77f93f" => :yosemite
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
