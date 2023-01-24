class Gstreamer < Formula
  desc "Development framework for multimedia applications"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.22.0.tar.xz"
  sha256 "78d21b5469ac93edafc6d8ceb63bc82f6cbbee94d2f866cca6b9252157ee0a09"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gstreamer.git", branch: "main"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gstreamer/"
    regex(/href=.*?gstreamer[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "a81bbd2b8ede4504609920eea3d4e908a6ef8c1006711882d21caa359583aef1"
    sha256 arm64_monterey: "76df20e4746ca63128f17e2439ed4e4cb76207044a289739cbf3156948bd8289"
    sha256 arm64_big_sur:  "e8146e692c253562731f4caefabf6077593df8ea2ed7e321c14398e5a57ae8a4"
    sha256 ventura:        "205272cca1648d3495603171c7174d4fbb3072a7dcce5f7847e34282b4280b75"
    sha256 monterey:       "6b9306bbc88b4b86db3578d37f7e67a0904eecece00b7af42a49afd5deb7a8f7"
    sha256 big_sur:        "98e5374f5f6c70b8c72f2182cd5dcee45704e66ea98be561a52bd30ff4d28004"
    sha256 x86_64_linux:   "3560eb3799b8070c94e4d07d432974dbfd1bdd06b956e32280c9e0b8e40a163c"
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
