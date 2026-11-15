class GlibNetworking < Formula
  desc "Network related modules for glib"
  homepage "https://gitlab.gnome.org/GNOME/glib-networking"
  url "https://download.gnome.org/sources/glib-networking/2.90/glib-networking-2.90.1.tar.xz"
  sha256 "ea95636590098355a05e3027579dba1a9a950b05e456b2488ea03d82e4b6c18a"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  # This regex is intended to avoid the `Gnome` strategy's version filtering
  # logic while maintaining the "even-numbered minor is stable" behavior, as
  # minor versions >= 90 are still stable in this case.
  livecheck do
    url :stable
    regex(/glib-networking[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256               arm64_golden_gate: "d29d9f4eb558298dc6eff44d95783df7729eca49a11ffc79d3e86c8da175d291"
    sha256               arm64_tahoe:       "91c6c43978f91a348e3e622d117b1f02b46b0ce3ade7d414160819b7d48e67c3"
    sha256               arm64_sequoia:     "81429551d7888762f6e7fc1d776dd9bbd1b494ca3bea6eae94ff675e06645642"
    sha256 cellar: :any, arm64_linux:       "a60feae8c630e3c3fa6e7576ff76514c2e816c4856e161febe5dac5d57efb572"
    sha256 cellar: :any, x86_64_linux:      "d44392d3fe60dd996c2c4b6a955a3f796ad87bd733eb152fcdddb7a405925479"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "gnutls"
  depends_on "gsettings-desktop-schemas"

  on_macos do
    depends_on "gettext"
  end

  link_overwrite "lib/gio/modules"

  def install
    # stop gnome.post_install from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"

    args = %w[
      -Dlibproxy=disabled
      -Dopenssl=disabled
      -Dgnome_proxy=disabled
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    run "{{HOMEBREW_PREFIX}}/opt/glib/bin/gio-querymodules",
        args: ["{{HOMEBREW_PREFIX}}/lib/gio/modules"]
  end

  test do
    (testpath/"gtls-test.c").write <<~C
      #include <gio/gio.h>
      int main (int argc, char *argv[])
      {
        if (g_tls_backend_supports_tls (g_tls_backend_get_default()))
          return 0;
        else
          return 1;
      }
    C

    # From `pkg-config --cflags --libs gio-2.0`
    flags = [
      "-D_REENTRANT",
      "-I#{HOMEBREW_PREFIX}/include/glib-2.0",
      "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include",
      "-I#{HOMEBREW_PREFIX}/opt/gettext/include",
      "-L#{HOMEBREW_PREFIX}/lib",
      "-L#{HOMEBREW_PREFIX}/opt/gettext/lib",
      "-lgio-2.0", "-lgobject-2.0", "-lglib-2.0"
    ]

    system ENV.cc, "gtls-test.c", "-o", "gtls-test", *flags
    system "./gtls-test"
  end
end
