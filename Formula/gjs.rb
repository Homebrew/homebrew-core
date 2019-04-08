class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.56/gjs-1.56.1.tar.xz"
  sha256 "6724f10e451eaf867e10f0badc3e1e606d823cf5b4c50c5129ee0106b2c1d473"

  bottle do
    sha256 "ba510b716d60d4babd4b350cae48d2bcc9d7891183f34903eb34a5ea3e9e27de" => :mojave
    sha256 "a9832480c3b2d64050669d68d8aae6629137a647fe6382b374a2c1ab01c8cccf" => :high_sierra
    sha256 "bda3425cf46cabb1df93668c0beebee1818f2c0f65c5932c4dfef208835ddee6" => :sierra
  end

  depends_on "autoconf@2.13" => :build
  depends_on "pkg-config" => :build
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "nspr"
  depends_on "readline"

  resource "mozjs60" do
    url "https://archive.mozilla.org/pub/firefox/releases/60.1.0esr/source/firefox-60.1.0esr.source.tar.xz"
    sha256 "a4e7bb80e7ebab19769b2b8940966349136a99aabd497034662cffa54ea30e40"
  end

  def install
    ENV.cxx11
    ENV["_MACOSX_DEPLOYMENT_TARGET"] = ENV["MACOSX_DEPLOYMENT_TARGET"]

    resource("mozjs60").stage do
      inreplace "config/rules.mk",
                "-install_name $(_LOADER_PATH)/$(SHARED_LIBRARY) ",
                "-install_name #{lib}/$(SHARED_LIBRARY) "
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
                              "--with-intl-api",
                              "--disable-jemalloc"
        system "make"
        system "make", "install"
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
      if (31 != GLib.Date.get_days_in_month(GLib.DateMonth.JANUARY, 2000))
        imports.system.exit(1)
    EOS
    system "#{bin}/gjs", "test.js"
  end
end
