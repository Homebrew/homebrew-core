class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.90/gjs-1.90.2.tar.xz"
  sha256 "f52c8e3d4185a6436dde44f9f2311684c9afa7eb68a5b2a98e3355343ba6f261"
  license all_of: ["LGPL-2.0-or-later", "MIT"]
  # TODO: Move to latest `spidermonkey` once gjs supports mozjs-153.
  # Also set deprecation date on `spidermonkey@140`.
  compatibility_version 1
  head "https://gitlab.gnome.org/GNOME/gjs.git", branch: "master"

  # This regex is intended to avoid the `Gnome` strategy's version filtering
  # logic while maintaining the "even-numbered minor is stable" behavior, as
  # minor versions >= 90 are still stable in this case.
  livecheck do
    url :stable
    regex(/gjs[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    manifest_sha256 "4be364b7e9f087a6ce1a1ffc93569f48879b38df25514de555443c9dea6568dd"
    sha256 arm64_golden_gate: "7d18102d51a2d1ecfe24bda60f92b6697c7c69847148cb933d7a5cdd95f2b270"
    sha256 arm64_tahoe:       "d2e6167902aaaa5f76043f2b2852b22eb4f4d2302d490df0bd7ba4ac6eb4ac87"
    sha256 arm64_sequoia:     "585b58a6feaccea2921e71468e71f49f1e01063358bbd9a8ac0b77b35d8b5023"
    sha256 arm64_linux:       "e903ab014d730dfd95bd566a11129d961a40f84c0668c0617b9941d565c512fe"
    sha256 x86_64_linux:      "7de67e24c33aaf0a614398e24d49fe97526f591f7dfbb8dcc6e5496eb0fc0a4c"
  end

  depends_on "gobject-introspection" => :build # for generate_gir
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "glib"
  depends_on "libx11"
  depends_on "readline"
  depends_on "spidermonkey@140"

  uses_from_macos "libffi"

  on_macos do
    depends_on "gettext"
  end

  deny_network_access!

  def install
    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    # allow GJS to find and load shared libraries
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: HOMEBREW_PREFIX/"lib")}" if OS.mac?

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

  post_install_steps do
    compile_gsettings_schemas
  end

  test do
    (testpath/"test.js").write <<~JS
      #!/usr/bin/env gjs
      const GLib = imports.gi.GLib;
      const Gio = imports.gi.Gio;
      if (31 != GLib.Date.get_days_in_month(GLib.DateMonth.JANUARY, 2000))
        imports.system.exit(1)
      if (!Gio.File.new_for_path("/").query_exists(null))
        imports.system.exit(1)
    JS
    system bin/"gjs", "test.js"
  end
end
