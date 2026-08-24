class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.88/gjs-1.88.1.tar.xz"
  sha256 "767bab80e665d672cb00563c25f0b392a9ec8c2996ed1d4454c698b4c2f0a3d9"
  license all_of: ["LGPL-2.0-or-later", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gjs.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "cd60dfefcd32590d2bad0baa7b9e8b62a9ef17ed66b519c1c242aaec870c956d"
    sha256 arm64_sequoia: "4f56f844683bd3adde37fc5324b0cda2d241015d1b164bcaa41eb63df4f26a88"
    sha256 arm64_sonoma:  "80a5d74f635a3d6511a242e30aa06a4f580d135ad4ce5cc4a8a8beb02593119e"
    sha256 sonoma:        "cb10584a8d4f5e23b81e40096e9a1a1b4841d2bf8f097537c23ac5c78eb6ced2"
    sha256 arm64_linux:   "ed006abd3321b958ba48d5369056af0ae1c1463d0b93c3203bbab158c97fbacc"
    sha256 x86_64_linux:  "1e0d9a70aebf146c9ac9d0f1b051631d15923f1b70909051b7f65ae4b32db07c"
  end

  depends_on "gobject-introspection" => :build # for generate_gir
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "glib"
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
