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
    sha256 arm64_golden_gate: "dac6814353d5aa4867f37e007a2efb5906eafefe7b9f43bf66592c97e76fd0f5"
    sha256 arm64_tahoe:       "067f6d6975f0c99543a333890d39e26810e587d9d7fa819e1783bfe1afcdf834"
    sha256 arm64_sequoia:     "fd873f01f7508ecea864049ef226f0123926055d6e19f6058b5a97fd44c5548a"
    sha256 arm64_linux:       "02327fa4f9a3a8c5c07c63c962b613464d16b6e76748352fefae7bc93cca21ff"
    sha256 x86_64_linux:      "0dc866c495788a3dd7f67db35bf19c425e262b716f47bac636f8cb869d6aecba"
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
    ENV.append "LDFLAGS", "-Wl,-rpath,#{HOMEBREW_PREFIX}/lib" if OS.mac?

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
