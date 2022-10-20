class Gstreamer < Formula
  desc "Development framework for multimedia applications"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.20.3.tar.xz"
  sha256 "607daf64bbbd5fb18af9d17e21c0d22c4d702fffe83b23cb22d1b1af2ca23a2a"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gstreamer.git", branch: "main"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gstreamer/"
    regex(/href=.*?gstreamer[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "7f03d06580c258e8ff4cdde94e5932ef2a99c7c3f15f8f36ecdbc0c4c9f17905"
    sha256 arm64_big_sur:  "033ee78615f10343a529047b3854cc88f4fd69df97e763b8e5f9ecf4c05e1151"
    sha256 monterey:       "f248dc88833ae6536f94203f2e3f0ebd72c4d93e5c75ab3c971e9df951ccd5fa"
    sha256 big_sur:        "3e063264325d343476e2f3a6547d8ea66bd0bc1be71c80a21b2e65e7ae0a7de0"
    sha256 catalina:       "13ae2cb01e7865295d0c09658b5188e0bb2d855ec8d8e24358d77744b6ecca5c"
    sha256 x86_64_linux:   "cf5fdc1d796c48f5d321191c48b670a2f44c42ff0c8f855ba182158194955dbb"
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
