class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.66/gjs-1.66.1.tar.xz"
  sha256 "8d4240455eff642c8bf6d9805077e33e0a60cb2ea13f77a55f7f30c29668344c"
  license all_of: ["LGPL-2.0-or-later", "MIT"]

  livecheck do
    url :stable
  end

  bottle do
    sha256 "1d10fa86fecf3d354dc595db175548427f112943f84a5076222b978c9aff9cf7" => :big_sur
    sha256 "819aaf721030c22a9f479fca06f52490a2df2b9d2731377d35bf017509723a17" => :catalina
    sha256 "bc1a84cd054dc1b0918f956b9c88601edf95af714a3a41e08ec3c6c310d4d2c3" => :mojave
    sha256 "2289aed2c52497f646b73861b4d7f6291a860abf332c5cab65f3581c441b2ad9" => :high_sierra
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
    url "https://archive.mozilla.org/pub/firefox/releases/78.2.0esr/source/firefox-78.2.0esr.source.tar.xz"
    sha256 "965ccfcbb8c0aa97639911997c54be0fcf896fd388b03138952089af675ea918"
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
                "sdk_max_version = Version('11.0')"
      inreplace "config/rules.mk",
                "-install_name $(_LOADER_PATH)/$(SHARED_LIBRARY) ",
                "-install_name #{lib}/$(SHARED_LIBRARY) "
      inreplace "old-configure", "-Wl,-executable_path,${DIST}/bin", ""

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
