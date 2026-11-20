class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.90/gjs-1.90.1.tar.xz"
  sha256 "05ceaa80f48e3782e5c44938572fad863e02b8c4a6c55657a99aa81db8ce9efa"
  license all_of: ["LGPL-2.0-or-later", "MIT"]
  # TODO: Move to latest `spidermonkey` once gjs supports mozjs-153.
  # Also set deprecation date on `spidermonkey@140`.
  revision 2
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
    rebuild 1
    sha256 arm64_golden_gate: "7725fd75c35240caa3c96f7b2e1a20d100a3cb39ad42ae3dc6792c30f4983cf7"
    sha256 arm64_tahoe:       "22cebb7cf538f9b49d288ff8400125de9efbac44869c5ea391a4f85922c59457"
    sha256 arm64_sequoia:     "4a2b86d73fa23bb853f5f6510e9ad67b4a482b1636628f2d626218ef3d0123b2"
    sha256 arm64_linux:       "f0d6471dbb8db2f744a55b2174bbd4db9fe18186a0ba60774857a247033c5b42"
    sha256 x86_64_linux:      "f40d198c3eac86406c2d2eddfccdc4d728151ae3374be0dd9de8301a5218d877"
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
