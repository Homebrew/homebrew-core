class Gstreamer < Formula
  desc "Development framework for multimedia applications"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.18.4.tar.xz"
  sha256 "9aeec99b38e310817012aa2d1d76573b787af47f8a725a65b833880a094dfbc5"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gstreamer.git"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gstreamer/"
    regex(/href=.*?gstreamer[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "11505edb762ff75626deed74777d893b939929a7a4bbe152d4c1623a0e7cc38a"
    sha256 arm64_big_sur:  "d62ea2ea98bd22267eabf676f8ec577df5eac27e7656e56545767b909d2224d5"
    sha256 monterey:       "a3adca24f420ef935184de4acf71b6a24dde2b7dcce718e419c60b54c24b8f9c"
    sha256 big_sur:        "a2d62c11bf92e6d4f2d02d1dff4558e945f6dc10b27f435c14824de9d2fdba48"
    sha256 catalina:       "9fcc5eb54cebede4c30ed3bacbf82fb8272471bd0a80cbc0a63b503a79994371"
    sha256 mojave:         "259ae892b842f10c590240abfc97e2af6d6c93f67d1362da1d858e913d3ddbd1"
    sha256 x86_64_linux:   "ed6878d62c1ae4e7f007ddad5d307b84bef65a8ce7637aa65dcf9e2b6aebaaf9"
  end

  depends_on "bison" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  uses_from_macos "flex" => :build

  def install
    # Ban trying to chown to root.
    # https://bugzilla.gnome.org/show_bug.cgi?id=750367
    args = std_meson_args + %w[
      -Dintrospection=enabled
      -Dptp-helper-permissions=none
    ]

    # Look for plugins in HOMEBREW_PREFIX/lib/gstreamer-1.0 instead of
    # HOMEBREW_PREFIX/Cellar/gstreamer/1.0/lib/gstreamer-1.0, so we'll find
    # plugins installed by other packages without setting GST_PLUGIN_PATH in
    # the environment.
    inreplace "meson.build",
      "cdata.set_quoted('PLUGINDIR', join_paths(get_option('prefix'), get_option('libdir'), 'gstreamer-1.0'))",
      "cdata.set_quoted('PLUGINDIR', '#{HOMEBREW_PREFIX}/lib/gstreamer-1.0')"

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def caveats
    <<~EOS
      Consider also installing gst-plugins-base and gst-plugins-good.

      The gst-plugins-* packages contain gstreamer-video-1.0, gstreamer-audio-1.0,
      and other components needed by most gstreamer applications.
    EOS
  end

  test do
    system bin/"gst-inspect-1.0"
  end
end
