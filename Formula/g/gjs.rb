class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.84/gjs-1.84.1.tar.xz"
  sha256 "44796b91318dbbe221a13909f00fd872ef92f38c68603e0e3574e46bc6bac32c"
  license all_of: ["LGPL-2.0-or-later", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gjs.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "41ff4303b958dc47da84f02e9beb26862bdff17a0a19bc7db4ca9277950ae08c"
    sha256 arm64_sonoma:  "3c8aeb3f5754c79adf62ab2b2b5060e954b5b7fed7480a1cf63980769dfd1a49"
    sha256 arm64_ventura: "1bf97f04a7c89a514d87dc4e3af9e5313a9d8d5d845cd9280847f3796a0dddcd"
    sha256 sonoma:        "3aaacc7af5be7d09fd22f818a3305edc5a8396d101980e2abaecc50c48bfb28c"
    sha256 ventura:       "2620575c227e4b02d8e6ba9beea1670e7ea9775e379ca8ea64600abd02fae50a"
    sha256 arm64_linux:   "538c55600494b4313233223fd2f155388c65de83fd1475628351bfbb0284bd6e"
    sha256 x86_64_linux:  "2d3994ac90659902a716b45f0661e48542708703827580c5c06361459ce23970"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  depends_on "cairo"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "libx11"
  depends_on "readline"
  depends_on "spidermonkey"

  uses_from_macos "libffi"

  on_macos do
    depends_on "gettext"
  end

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
    (testpath/"test.js").write <<~JS
      #!/usr/bin/env gjs
      const GLib = imports.gi.GLib;
      if (31 != GLib.Date.get_days_in_month(GLib.DateMonth.JANUARY, 2000))
        imports.system.exit(1)
    JS
    system bin/"gjs", "test.js"
  end
end
