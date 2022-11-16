class Gstreamer < Formula
  desc "Development framework for multimedia applications"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.20.4.tar.xz"
  sha256 "67c1edf8c3c339cda5dde85f4f7b953bb9607c2d13ae970e2491c5c4c055ef5f"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gstreamer.git", branch: "main"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gstreamer/"
    regex(/href=.*?gstreamer[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "1474de51672852a3c9e1f7a3ed8fd89eb46cb61606130fe6cf883772f0cca44b"
    sha256 arm64_monterey: "9ed5bde4e69defa581b8fb7e32dea318fa9d58af7c9cf4a56914152e3da6d37e"
    sha256 arm64_big_sur:  "9b56794d090b1e832a79a3151be71182b310a0a011710b0caa592a69abf03a03"
    sha256 ventura:        "a41c1c035826595e51430b3de6430744bcfce719c0facef63d8fb98a1c01b6a0"
    sha256 monterey:       "5bb8499adfa323b0d87932d4b1cc4b1c0e320a0de46b8913eb74bd08e180f9a0"
    sha256 big_sur:        "141fcaa3f1bc72f4253cf671ea96828ff0364a5ccdc59303cba8ccefe4c977ee"
    sha256 catalina:       "be3027bdbeb6130f70f3a835d930151893d88d104a40ff9ffaa26f647ca80cc6"
    sha256 x86_64_linux:   "f2528cbc388e69ab820d42dc616d004a87aa5f8a4d61c2598362d73120f6f8e7"
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

    bin.env_script_all_files libexec/"bin", GST_PLUGIN_SYSTEM_PATH: HOMEBREW_PREFIX/"lib/gstreamer-1.0"
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
