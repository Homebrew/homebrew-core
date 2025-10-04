class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.86/gjs-1.86.0.tar.xz"
  sha256 "63448f7a57804d4c2a8d0c7f5e90e224d04d4eb2d560142c076c65a8eda00799"
  license all_of: ["LGPL-2.0-or-later", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gjs.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "0181d7c99322149ee550954433d97006ec608960a784a326ef1993340ec60c62"
    sha256 arm64_sequoia: "9db20e61a7b9a48e58e7c8344cf31eb724ba493fc75655580faa4c0d80555ccd"
    sha256 arm64_sonoma:  "75380121607e37a095c0a78a90191fbbb649fb516467a1033d837e7fb846b698"
    sha256 sonoma:        "d9a8dfc64d0dd5c709d3dc84e185dd34b7ec7b72ee83fd7677208d0b4c3e8e4f"
    sha256 arm64_linux:   "b06eacfddc724bce2a240e7d6bff4d21d4947b9e79221c71ec41f9de58e015d8"
    sha256 x86_64_linux:  "3317122a8ac4c1077cae41eef6bb7a189c6e52ae375ccf636ac5a9c50319bf81"
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
