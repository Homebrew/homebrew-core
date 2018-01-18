class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://wiki.gnome.org/Projects/Gjs"
  url "https://download.gnome.org/sources/gjs/1.50/gjs-1.50.3.tar.xz"
  sha256 "49962f0126886413fda28e2de13464c8a73f987c3bbf60a4a17e5f638172ce19"

  bottle do
    sha256 "bc5b7944eacc770184f21d5914d22fc4593ac09c8dfb7ac5d27fb7d2db5146ce" => :high_sierra
    sha256 "4e1067af2725c5eced0bd66b4bf99d1ace28304c552da25ca074855d492c109d" => :sierra
    sha256 "94ea72061a8d26bc795cd4b0bc0057d0da918db7c1a8037bf3de36e28536b3e9" => :el_capitan
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
    (testpath/"test.js").write <<~EOS
      #!/usr/bin/env gjs
      const GLib = imports.gi.GLib;
    EOS
    system "#{bin}/gjs", "test.js"
  end
end
