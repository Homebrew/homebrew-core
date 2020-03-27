class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.64/gjs-1.64.3.tar.xz"
  sha256 "9d96e154601c39f901ea2205b85f3bf4106cffe80dd5d97ab9f5ae56331185e6"
  revision 1

  bottle do
    sha256 "df98384f46fed27842f6891a3a7fe46afc198c370275b98fd0b720e8952ca293" => :catalina
    sha256 "0999ade386d5397547e9907df670da537ec30ff2f43f133936279961bcb8cdf2" => :mojave
    sha256 "611383231c504ea40be930359e663d6e91e5130c30bc1ac78ec4de96339bc1d3" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "llvm"
  depends_on "nspr"
  depends_on "readline"

  resource "autoconf@213" do
    url "https://ftp.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz"
    mirror "https://ftpmirror.gnu.org/autoconf/autoconf-2.13.tar.gz"
    sha256 "f0611136bee505811e9ca11ca7ac188ef5323a8e2ef19cffd3edb3cf08fd791e"
  end

  resource "mozjs68" do
    url "https://archive.mozilla.org/pub/firefox/releases/68.8.0esr/source/firefox-68.8.0esr.source.tar.xz"
    sha256 "fa5b2266d225878d4b35694678f79fd7e7a6d3c62759a40326129bd90f63e842"
  end

  def install
    ENV.cxx11

    resource("autoconf@213").stage do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--program-suffix=213",
                            "--prefix=#{buildpath}/autoconf",
                            "--infodir=#{buildpath}/autoconf/share/info",
                            "--datadir=#{buildpath}/autoconf/share"
      system "make", "install"
    end

    resource("mozjs68").stage do
      inreplace "config/rules.mk",
                "-install_name $(_LOADER_PATH)/$(SHARED_LIBRARY) ",
                "-install_name #{lib}/$(SHARED_LIBRARY) "
      inreplace "old-configure", "-Wl,-executable_path,${DIST}/bin", ""
      inreplace "build/moz.configure/toolchain.configure",
                "sdk_max_version = Version('10.14')",
                "sdk_max_version = Version('10.16')"

      mkdir("build") do
        ENV["PYTHON"] = "python"
        ENV["_MACOSX_DEPLOYMENT_TARGET"] = ENV["MACOSX_DEPLOYMENT_TARGET"]
        ENV["CC"] = Formula["llvm"].opt_bin/"clang"
        ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
        ENV.prepend_path "PATH", buildpath/"autoconf/bin"
        system "../js/src/configure", "--prefix=#{prefix}",
                              "--with-system-nspr",
                              "--with-system-zlib",
                              "--with-system-icu",
                              "--enable-readline",
                              "--enable-shared-js",
                              "--enable-optimize",
                              "--enable-release",
                              "--with-intl-api",
                              "--disable-jemalloc",
                              "--disable-xcode-checks"
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

    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    args = std_meson_args + %w[
      -Dprofiler=disabled
      -Dinstalled_tests=false
      -Dbsymbolic_functions=false
      -Dskip_dbus_tests=true
      -Dskip_gtk_tests=true
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
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
