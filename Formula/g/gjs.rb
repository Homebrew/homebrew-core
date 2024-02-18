class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.78/gjs-1.78.4.tar.xz"
  sha256 "9aec7ab872c2050404907ae94f0ae7abec8a54bd9c894ddb5c2d0f51e932b9a1"
  license all_of: ["LGPL-2.0-or-later", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gjs.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:  "d88350bddb9aaef1bcf23ab0d4a5fd11c13b288bf73995c6a4003e77ad54b099"
    sha256 arm64_ventura: "32b5fca08042983e588453ad345605b115f1d14e18df036c142e2be85dabc933"
    sha256 sonoma:        "1261efe742c5b8ce009258801afe02070e98a0d9206c8a29349330d542468372"
    sha256 ventura:       "d4ed1e823844542318ea23757d4d6274027dd23b57425fc08727d0b003ae8f49"
    sha256 x86_64_linux:  "8ac3b5db9e0133953f2b0f80e89835bf5247dec6a81f95f421076d5e376debba"
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
