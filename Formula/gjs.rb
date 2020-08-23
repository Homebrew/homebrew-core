class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.64/gjs-1.64.4.tar.xz"
  sha256 "a3cc3a8eda87074b2c363ffe28b29a5202d7f12914b6973f199acf2d1816d44c"

  bottle do
    sha256 "48ab51876b8cb4b93914f6ec9f97134d19883a3aecdf0fceeb39ba4565820c84" => :catalina
    sha256 "3605114b6a6168aac10d3544cb44a8c543b94d1938f22edfe3b898e1f967136c" => :mojave
    sha256 "37212a55eeac304e95953c4681c42a6eddf82eb62eca40bedc459c943ce55580" => :high_sierra
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
