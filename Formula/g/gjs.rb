class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.80/gjs-1.80.2.tar.xz"
  sha256 "135e39c5ac591096233e557cfe577d64093f5054411d47cb2e214bad7d4199bd"
  license all_of: ["LGPL-2.0-or-later", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gjs.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:  "9fbd2b15e1b98c7590dd370deb21db644d2676a831bae75df410092e16450414"
    sha256 arm64_ventura: "dbf074036561f646a5bc0344d5df9186c273529678fff3ab7d1b68caaf16da12"
    sha256 sonoma:        "4e9412dc31df82b06d88bc7cb54d1d6d9ffcc6d5dd5c129265786b3fd28feda8"
    sha256 ventura:       "d29305210a5ed228544d029b667253c7df7364a155dd495845d2882f66d4b6e9"
    sha256 x86_64_linux:  "0b645baee03ad6e32164fe91105216082dc85fe952becd90f7b578a03c18324e"
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
