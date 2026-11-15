class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.29.0.tar.xz"
  sha256 "248bc76141f2b8b006ccba9e0bb2cb46cbcb1be4181a1cf2728187f778853654"
  license all_of: ["GPL-2.0-only", "LGPL-2.1-only", "BSD-2-Clause", "FTL", "zlib-acknowledgement"]

  livecheck do
    url "https://download.enlightenment.org/rel/libs/efl/"
    regex(/href=.*?efl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "dc4103c6c07e0aa7d98a760407124148c7e11573db0bab26b14f64655425a1f7"
    sha256 arm64_tahoe:       "02b4765b2d84f0b9c921c86754140ddc204d1fbdbabe32bade328d3a283661a3"
    sha256 arm64_sequoia:     "fb7e94400484464d6258c55231fe7ee188de9fbf710fa68a9f0b483fa9d5ed65"
    sha256 arm64_linux:       "3cd90d3cd15576fb436f2553a025a4c1b4abd84c915847fd358438a7f71206e0"
    sha256 x86_64_linux:      "32cd21c2d78fd8fbf118b1ce96a846508fd931b2f25b30e9a55c1fcfa18e9291"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "bullet"
  depends_on "cairo"
  depends_on "dbus"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "gstreamer"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libsndfile"
  depends_on "libspectre"
  depends_on "libtiff"
  depends_on "luajit"
  depends_on "lz4"
  depends_on "openjpeg"
  depends_on "openssl@4"
  depends_on "poppler"
  depends_on "pulseaudio"
  depends_on "shared-mime-info"
  depends_on "webp"

  on_macos do
    depends_on "gdk-pixbuf"
    depends_on "little-cms2"
  end

  on_linux do
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  # Fix build on macOS where OpenGL headers lack `glGetShaderPrecisionFormat`
  patch :DATA

  def install
    args = %w[
      -Davahi=false
      -Dbuild-examples=false
      -Dbuild-tests=false
      -Dembedded-lz4=false
      -Deeze=false
      -Dglib=true
      -Dinput=false
      -Dlibmount=false
      -Dopengl=full
      -Dphysics=true
      -Dpipewire=false
      -Dsystemd=false
      -Dv4l2=false
      -Dx11=false
      -Dlua-interpreter=luajit
    ]
    args << "-Dcocoa=true" if OS.mac?

    # Install in our Cellar - not dbus's
    inreplace "dbus-services/meson.build", "dep.get_variable(pkgconfig : 'session_bus_services_dir')",
                                           "'#{share}/dbus-1/services'"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    update_mime_database
  end

  test do
    system bin/"edje_cc", "-V"
    system bin/"eet", "-V"
  end
end
__END__
--- a/src/modules/evas/engines/gl_generic/evas_ector_gl_span_shader.c
+++ b/src/modules/evas/engines/gl_generic/evas_ector_gl_span_shader.c
@@ -291,8 +291,14 @@ _span_fragment_highp_supported(void)
 
    if (_span_fs_highp >= 0) return _span_fs_highp;
 
+#ifdef GL_HIGH_FLOAT
    glGetShaderPrecisionFormat(GL_FRAGMENT_SHADER, GL_HIGH_FLOAT,
                               range, &precision);
+#else
+   // macOS's legacy GL headers lack the ES2 precision query, and desktop GL
+   // always supports fragment highp.
+   range[0] = range[1] = precision = 1;
+#endif
    _span_fs_highp = ((range[0] != 0) || (range[1] != 0) || (precision != 0)) ? 1 : 0;
    if (!_span_fs_highp)
      INF("span shader: fragment highp unsupported, falling back to mediump");
