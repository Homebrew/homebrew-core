class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.88/gjs-1.88.0.tar.xz"
  sha256 "30a0b9f3317e8e60b1896db2903c70e8b0cd33df953c328755803a75191dc453"
  license all_of: ["LGPL-2.0-or-later", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gjs.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "812b6a7f5c6131bc34c59ec5c31bb2fba45d74729b4062565ec8704cfee017fc"
    sha256 arm64_sequoia: "4809c33460fed027d9fce6c63a5c4ff93733944b7e25eda3e54b5af293c36d71"
    sha256 arm64_sonoma:  "85972643a8124ccdb5fcc2006029322b46dd1932b6809808b3a8e57457e64e91"
    sha256 sonoma:        "77ef68855a431351639f441fe0bd1d9ea868df24a7e26e43df73e47f006eb418"
    sha256 arm64_linux:   "0c39907f6fce1361e240a49a84f118bf9cfae1031cb5fac2e835d874ba84122b"
    sha256 x86_64_linux:  "79b3c19b526140b65ff193f2710d5aed8c9e242e1dec065a6ca8fad482d4b8c6"
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
