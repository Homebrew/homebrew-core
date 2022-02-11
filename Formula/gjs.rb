class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  license all_of: ["LGPL-2.0-or-later", "MIT"]

  stable do
    url "https://download.gnome.org/sources/gjs/1.70/gjs-1.70.1.tar.xz"
    sha256 "bbdc0eec7cf25fbc534769f6a1fb2c7a18e17b871efdb0ca58e9abf08b28003f"

    depends_on "spidermonkey@78"
  end

  bottle do
    sha256 big_sur:  "30567ac5c7946ccfe9f8b6411a26c1c98bfd5a66c2f39107beeb2eea0dbec123"
    sha256 catalina: "c34ecceabbd268bfb7b4076c66934a8960b5587c5e777e3390dcda8a8aa45603"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/gjs.git", branch: "master"

    depends_on "spidermonkey"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "readline"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # meson ERROR: SpiderMonkey sanity check: DID NOT COMPILE

  def install
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
