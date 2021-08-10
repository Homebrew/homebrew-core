class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.68/gjs-1.68.2.tar.xz"
  sha256 "70ff02ada682f130338ec5cc4c51103dc0e5cab8d537eb76b181ec512a65ee30"
  license all_of: ["LGPL-2.0-or-later", "MIT"]

  bottle do
    sha256 big_sur:  "d4e8b86038f300ba1cddf791d40b0ccf96f0ef9507f8edc4bef1a03ef15712ec"
    sha256 catalina: "89bbd0ffaf69b849e42a7d49558bf311e4e1669a39c2d622cd36159468c90353"
    sha256 mojave:   "efc170f9c06a89b46f6e75f396a434b3c6ad4867446b0e51f4f833b152e37e47"
  end

  depends_on "autoconf@2.13" => :build
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

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "mozjs78" do
    url "https://archive.mozilla.org/pub/firefox/releases/78.10.1esr/source/firefox-78.10.1esr.source.tar.xz"
    sha256 "c41f45072b0eb84b9c5dcb381298f91d49249db97784c7e173b5f210cd15cf3f"
  end

  def install
    ENV.cxx11

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
