class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.72/gjs-1.72.2.tar.xz"
  sha256 "ddee379bdc5a7d303a5d894be2b281beb8ac54508604e7d3f20781a869da3977"
  license all_of: ["LGPL-2.0-or-later", "MIT"]
  revision 1
  head "https://gitlab.gnome.org/GNOME/gjs.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "f0a295e8c84751bee9a8fcd98a5d8c62e43880c9eec5b886038e93e1fe19ff33"
    sha256 arm64_big_sur:  "249d7537519060fb0672a4a8fa17c713a6278e54b6a7ff5049bd292bef3628aa"
    sha256 monterey:       "bb6d7a227aed9945f0a48bf7fd93e2bd0101a2a225891b649d96ec3df7c5f6de"
    sha256 big_sur:        "3139f9a2a71b856f9dd87cee9ed20776f5fa3e66ef5e8b44f54b0d0160f84c17"
    sha256 catalina:       "6b30a5d8916662ac2540f39027b3d94adb61f923cec7613fc02ff05b1149e51a"
    sha256 x86_64_linux:   "66ef504c92dfbb8122b6abfed2c80306d53b5fd22e9560a45d20ae734b2e744a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gobject-introspection"
  depends_on "readline"
  depends_on "spidermonkey"

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
