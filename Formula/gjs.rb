class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.72/gjs-1.72.2.tar.xz"
  sha256 "ddee379bdc5a7d303a5d894be2b281beb8ac54508604e7d3f20781a869da3977"
  license all_of: ["LGPL-2.0-or-later", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gjs.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "f87015a14aa3a783ae1625401d01c13468cfc8ee42a16e8e556697e0c7602fa3"
    sha256 arm64_big_sur:  "4b735ead177cf2c0016cfdf6bddc501d7872bcd955c27d767c4ca91c21c589d4"
    sha256 monterey:       "36af3b4b986008a88b64567b73410899823c370bc2130b9659a6ce72ba52ba58"
    sha256 big_sur:        "fa3f7ac95c0ca3977f9c9e4fac7c6064a287eca183d13e00b8d9f51c02a6abf7"
    sha256 catalina:       "909ce1eaf04173aaa4cb1b72de69f02014346b5bea14c7c5279c5bff607baa12"
    sha256 x86_64_linux:   "3466f76c4f2c7e93c58908f7ee50612af7f124419a693f020604d49288280a23"
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
