class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.72/gjs-1.72.0.tar.xz"
  sha256 "3ef0caf716e3920dd61f7748f6d56e476cc0fc18351ad0548e7df1a0ab9bdcad"
  license all_of: ["LGPL-2.0-or-later", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gjs.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "5be9066d306e9dbd1796dd774b165cb92d210bdb85fb9a351dfb9dddad5c92d4"
    sha256 arm64_big_sur:  "6caabfb5e97099f72ac8df0d0754ac7aed0c0de0030dfc02345c4516361468e6"
    sha256 monterey:       "557ffe778d84c49b76e90d9d9d4a6fbb0cc620529cd49ce75b965d411a2e6b95"
    sha256 big_sur:        "6f35338389f3313ac4146069d26d9a6e7639c8094d15287b8ab4ac83b991b3f3"
    sha256 catalina:       "26b264865727dcdc99aac87b347d4b6d109a43d7f79027baa7754db4c37625aa"
    sha256 x86_64_linux:   "60224ecb303a7d6a4ba31253dfdc779ce7418eb7c5711717a453f0eab634ea4b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gobject-introspection"
  depends_on "readline"
  depends_on "spidermonkey"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # meson ERROR: SpiderMonkey sanity check: DID NOT COMPILE

  def install
    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    args = std_meson_args + %w[
      -Dprofiler=disabled
      -Dreadline=enabled
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
