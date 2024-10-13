class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.82/gjs-1.82.0.tar.xz"
  sha256 "14490236868d0bf822f7aa7cf38fcd333e7620760fdcf50e932423611f626623"
  license all_of: ["LGPL-2.0-or-later", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gjs.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "0ea3774bdad42f128eebdb3dbf172bcc2ba873949f184f596e37fdaf6eb38e16"
    sha256 arm64_sonoma:  "96ba1bb62446f5e8ca2fef98bd6cc5fbe0b53022eee6b60f13cd0357b2e8c583"
    sha256 arm64_ventura: "acfe37bfa6c317a2908a26230284cd456fe73182a149d534f5dc9a371f859b88"
    sha256 sonoma:        "9bad91e40788572710f49bb1bfedc4f9316aeb89315cda806ba134cacdf88bf4"
    sha256 ventura:       "bff55840e7427c9fc9b489e25a9baa23feaa6f8fcd7bda848f9fae7da35d327d"
    sha256 x86_64_linux:  "3212726c0076240c4f842c381e16be9a5d7fa99556ada7ff9df8168f83f77752"
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
