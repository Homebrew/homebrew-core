class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.80/gjs-1.80.2.tar.xz"
  sha256 "135e39c5ac591096233e557cfe577d64093f5054411d47cb2e214bad7d4199bd"
  license all_of: ["LGPL-2.0-or-later", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gjs.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:  "b6c056e8b3636d052764830169090b6d22ec1ad956d214fb614149c9b6dfe27f"
    sha256 arm64_ventura: "1a6f27e55fb9e52a95965657f56448d50d4d16b818ae2251f443f19773f318ae"
    sha256 sonoma:        "051a70886e726d034610ea33aa4e2947661824c49e165a3fa794fd6f980c1b63"
    sha256 ventura:       "92d8f1a82b6ed5933fb68ccec2bbf7ec325ed6858a598c6ac497f34421d105e4"
    sha256 x86_64_linux:  "db86e13bd209eeb4cfe0002ad93854fa157f2901360ba31778a77f99f32c52f3"
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

    args = %w[
      -Dprofiler=disabled
      -Dreadline=enabled
      -Dinstalled_tests=false
      -Dbsymbolic_functions=false
      -Dskip_dbus_tests=true
      -Dskip_gtk_tests=true
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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
    system bin/"gjs", "test.js"
  end
end
