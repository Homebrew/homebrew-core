class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.80/gjs-1.80.1.tar.xz"
  sha256 "acfe810ccb1e8e5b43b567ef28575340362eb9c04d140e2605633d74da1d9946"
  license all_of: ["LGPL-2.0-or-later", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gjs.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:  "ec602393af3d3fcb7dd101eed52524d5aa7183bd5a4068b23f7fe333fa511732"
    sha256 arm64_ventura: "f2b85b444f83f00e99468893ce34ba51ddd0daf14186a3f8b83e598099a1da44"
    sha256 sonoma:        "a91568b6d3ef781037735993af170a1c5ab88cbf13c5edfbfb5e87007b51746d"
    sha256 ventura:       "24db9b7ae94a87f01667ed4c89cc003288ff4b8eb0f22b9d1450cf4e04c999fb"
    sha256 x86_64_linux:  "2c433fe72ded8e23a7459fa5781cdaf778586ee40d41f87edaac58a389af1e90"
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
