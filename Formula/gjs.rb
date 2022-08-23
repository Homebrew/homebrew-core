class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.72/gjs-1.72.2.tar.xz"
  sha256 "ddee379bdc5a7d303a5d894be2b281beb8ac54508604e7d3f20781a869da3977"
  license all_of: ["LGPL-2.0-or-later", "MIT"]
  revision 1
  head "https://gitlab.gnome.org/GNOME/gjs.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "b39d6b4d433635754d4ff6788db44a46dee4b68c618c01b34495799fed2a57a4"
    sha256 arm64_big_sur:  "1e0fc8102b5c9dee82491b4a08a12b0bc289f758eb5ede150cd1f322b915ba96"
    sha256 monterey:       "75a81c1f81a8a7cd68b4a00de221bce017dbae1b5853ef8ba5e52bfccb6a7c5f"
    sha256 big_sur:        "53d7e2a36eee56da9548a730450be047fb5e62c7d960bc4a5a7d367000753199"
    sha256 catalina:       "43b1f44d78bea7bc563d70e0702cc18743edbdea9674a31f49a5e30a72bfff2c"
    sha256 x86_64_linux:   "4db14cedaffd84d55ff7da4a64984c5f7b46746d045d1320fbfe0abbf28f1c82"
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
