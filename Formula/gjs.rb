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
    sha256 monterey:     "4366423967ed653d2fa9ecf3ed9297456c1b7c9206d0ceb590a343af007600fe"
    sha256 big_sur:      "9d531cf47c4d4be12eab2e89c40c6d904c7a71b5e7683d77a6eb36eaead4df9a"
    sha256 catalina:     "4f764d816b6a8e40103b334385c043a3189604b5491658f72ed0fdba0fd55635"
    sha256 x86_64_linux: "eb196582efbb21df0e6fb6e4632dbb2ea6c0b7b2c7deac1e068f2a9110409950"
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
