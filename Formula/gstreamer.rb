class Gstreamer < Formula
  desc "Development framework for multimedia applications"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.20.2.tar.xz"
  sha256 "df24e8792691a02dfe003b3833a51f1dbc6c3331ae625d143b17da939ceb5e0a"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gstreamer.git", branch: "main"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gstreamer/"
    regex(/href=.*?gstreamer[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "59f2c5fb93a71647932931aca4a8153720f4f22fa2a7a2b9d41886bae3e10dab"
    sha256 arm64_big_sur:  "2c97a9e6e80fd43b98302c34f485e27aebdba41207030e3273b503542c4744a0"
    sha256 monterey:       "b63640fb86a0594a227bfc5331a90152a2cd68514577920f6ded7861b724743e"
    sha256 big_sur:        "063346f124b3676c3ec964e274f94e78e1a255a80f0711b7afcb49a38ecfad11"
    sha256 catalina:       "5d923ac9be1094abb372ee3b0c98ff34b7483ff65a6b2cd9b0a759d03df36b98"
    sha256 x86_64_linux:   "91b93bceab35daf1981c5927a0ae4bf108ce79d7863eda08e6e2845dc1f517c2"
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
