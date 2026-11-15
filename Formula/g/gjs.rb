class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.90/gjs-1.90.1.tar.xz"
  sha256 "05ceaa80f48e3782e5c44938572fad863e02b8c4a6c55657a99aa81db8ce9efa"
  license all_of: ["LGPL-2.0-or-later", "MIT"]
  # TODO: Move to latest `spidermonkey` once gjs supports mozjs-153.
  # Also set deprecation date on `spidermonkey@140`.
  revision 1
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
    sha256 arm64_golden_gate: "f93b65ca60e52b8833344bda506df19997c32d8a34e422548748bde277c89788"
    sha256 arm64_tahoe:       "a9e1b42017122494a80d4fce0d44f77cd88bf222bba5e179228228ffef1c3957"
    sha256 arm64_sequoia:     "4c7508614bf734d99e4cfab1c4f70869e871f641dd63de0761dd835e443db2d0"
    sha256 arm64_linux:       "b9e5d298a3204a855d54e3fac66c4a7e51cce1174c0043940e139581081b838f"
    sha256 x86_64_linux:      "81109de506c5915ba9e6884037aae5e25421bdf464b2d6220863917c89824172"
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

    # work around "Failed to load shared library 'libgobject-2.0.0.dylib'"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: formula_opt_lib("glib"))}" if OS.mac?

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
      if (31 != GLib.Date.get_days_in_month(GLib.DateMonth.JANUARY, 2000))
        imports.system.exit(1)
    JS
    system bin/"gjs", "test.js"
  end
end
