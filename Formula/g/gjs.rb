class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.88/gjs-1.88.0.tar.xz"
  sha256 "30a0b9f3317e8e60b1896db2903c70e8b0cd33df953c328755803a75191dc453"
  license all_of: ["LGPL-2.0-or-later", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gjs.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "5d0a14b4ac86338949a15e5f374e208d38887514075d22f22c144a364dfe8557"
    sha256 arm64_sequoia: "22f7d9bc15419b48a6fce97f6ff0cc8fec2f2508aa157e887ef01b10d779ee69"
    sha256 arm64_sonoma:  "c768be21228e57f2837bc9be96b3b10d59438a85c33bb1ef4145b05a772537c4"
    sha256 sonoma:        "0174fe5ca9ccfd3176d986aed546dbd8cde0b86c717d66213c2d17c55d18cd35"
    sha256 arm64_linux:   "47c4e9ebbb18242cac5ff5c1b8276c15aa4d77882eb1cf6a94282380af0d4f16"
    sha256 x86_64_linux:  "500a526ee59d19864fd08b18a441d3e01e2759236928b6e5257697ec4e7a2995"
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

    # work around "Failed to load shared library 'libgobject-2.0.0.dylib'"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: Formula["glib"].opt_lib)}" if OS.mac?

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
