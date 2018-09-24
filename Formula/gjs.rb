class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://wiki.gnome.org/Projects/Gjs"
  url "https://download.gnome.org/sources/gjs/1.54/gjs-1.54.1.tar.xz"
  sha256 "b197fe5812a0449f73f7a93ac85a4ee4941916bcf071ea39a67ddd231dc868bc"

  bottle do
    sha256 "daf905d8a4f887615ad7c94bbcd2d1fb20e4ebe972b4723a11c35df209b3786f" => :mojave
    sha256 "c489021983a56fe446820a8b8cf60c512f2403b832adf2dc128af3bc77dfd143" => :high_sierra
    sha256 "f4f93c38137fde79938a5a751ff259752a2464a5c61ff1deb1d5e5b8a8be906c" => :sierra
    sha256 "a61878736e0d935d053ac6eea9f92cf32a1e172c6ac5fd24bbfec4c768fd8097" => :el_capitan
  end

  depends_on "autoconf@2.13" => :build
  depends_on "pkg-config" => :build
  depends_on "gobject-introspection"
  depends_on "nspr"
  depends_on "readline"
  depends_on "gtk+3" => :recommended

  resource "mozjs60" do
    url "https://archive.mozilla.org/pub/firefox/releases/60.1.0esr/source/firefox-60.1.0esr.source.tar.xz"
    sha256 "a4e7bb80e7ebab19769b2b8940966349136a99aabd497034662cffa54ea30e40"
  end

  needs :cxx11

  def install
    ENV.cxx11
    ENV["_MACOSX_DEPLOYMENT_TARGET"] = ENV["MACOSX_DEPLOYMENT_TARGET"]

    resource("mozjs60").stage do
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
    EOS
    system "#{bin}/gjs", "test.js"
  end
end
