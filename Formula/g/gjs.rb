class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.72/gjs-1.72.2.tar.xz"
  sha256 "ddee379bdc5a7d303a5d894be2b281beb8ac54508604e7d3f20781a869da3977"
  license all_of: ["LGPL-2.0-or-later", "MIT"]
  revision 1
  head "https://gitlab.gnome.org/GNOME/gjs.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "5f60562a5307f0696c5e73e38794d7ad80099777d5d958c56a71ab411a224661"
    sha256 arm64_monterey: "100f273efb5cd89144a4305a1275ac99c7b1026a25e1f65dfcaccdc02cc8a916"
    sha256 arm64_big_sur:  "d23cd7df4f1bf1b60daf47cba34b9bcc588b6d3a282a686b081bad88c8520759"
    sha256 ventura:        "c506eaf1f420f4d72397d478c37f1bc786f798e7a511fc748d841ae9f8a2b6ff"
    sha256 monterey:       "83614a258ebcf824b37dc920f0b99e4cc13064e95fdad0d6e1df84b89bfd5c7a"
    sha256 big_sur:        "cb47ddff58ba48e4acc754b14a5a0be1d29e0c3c08f9fd619a661171f6739d67"
    sha256 catalina:       "27c87327610b1b83005d1df7688acabc2dab19a3089c89686602cfab384f0d02"
    sha256 x86_64_linux:   "877208d1996b9531e7cb347e3dab91769bf76b20b9d8b4ecaf6adf833a95718a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gobject-introspection"
  depends_on "readline"
  depends_on "spidermonkey"

  fails_with gcc: "5" # meson ERROR: SpiderMonkey sanity check: DID NOT COMPILE

  def install
    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    args = std_meson_args + %w[
      -Dprofiler=disabled
      -Dreadline=enabled
      -Dinstalled_tests=false
      -Dbsymbolic_functions=false
      -Dskip_dbus_tests=true
      -Dskip_gtk_tests=true
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
    system "#{bin}/gjs", "test.js"
  end
end
