class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.66/gjs-1.66.2.tar.xz"
  sha256 "bd7f5f8b171277cc0bb9ee1754b0240b62f06a76b8b18c968cf471b34ab34e59"
  license all_of: ["LGPL-2.0-or-later", "MIT"]

  bottle do
    sha256 big_sur:  "ed18080951a9b2cb2d3ff96e3bf17c91f488cd7499049c244957ae659ce9ab8d"
    sha256 catalina: "7bceef6e1b571940c226637d87d1e16eedfa3f575cdea33721a5a44cf78e6235"
    sha256 mojave:   "e343d4c00eb3de60ef83b019a5df16769f64e79a26b3c72898a5cae91559a8ce"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
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

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "mozjs78" do
    url "https://archive.mozilla.org/pub/firefox/releases/78.7.1esr/source/firefox-78.7.1esr.source.tar.xz"
    sha256 "5042783e2cf94d21dd990d2083800f05bc32f8ba65532a715c7be3cb7716b837"
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

    resource("six").stage do
      system Formula["python@3.8"].opt_bin/"python3", *Language::Python.setup_install_args(buildpath/"vendor")
    end

    resource("mozjs78").stage do
      inreplace "build/moz.configure/toolchain.configure",
                "sdk_max_version = Version('10.15.4')",
                "sdk_max_version = Version('11.99')"
      inreplace "config/rules.mk",
                "-install_name $(_LOADER_PATH)/$(SHARED_LIBRARY) ",
                "-install_name #{lib}/$(SHARED_LIBRARY) "
      inreplace "old-configure", "-Wl,-executable_path,${DIST}/bin", ""

      # Fix Big Sur build
      # Backport of https://hg.mozilla.org/mozilla-central/rev/c991b4d04c08d6fdd8228d9cf98c1f9d3c24f9ac
      inreplace "python/mozbuild/mozbuild/virtualenv.py",
                "os.environ['MACOSX_DEPLOYMENT_TARGET'] = sysconfig_target",
                "os.environ['MACOSX_DEPLOYMENT_TARGET'] = str(sysconfig_target)"

      mkdir("build") do
        xy = Language::Python.major_minor_version "python3"
        ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python#{xy}/site-packages"
        ENV["PYTHON"] = Formula["python@3.8"].opt_bin/"python3"
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
