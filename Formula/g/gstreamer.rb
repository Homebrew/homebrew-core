class Gstreamer < Formula
  desc "Development framework for multimedia applications"
  homepage "https://gstreamer.freedesktop.org/"
  license all_of: ["LGPL-2.0-or-later", "LGPL-2.1-or-later", "MIT"]

  stable do
    url "https://gitlab.freedesktop.org/gstreamer/gstreamer/-/archive/1.24.7/gstreamer-1.24.7.tar.bz2"
    sha256 "72b4454664dac0a0816dcddf673206296ad3b974afcbdb9a8cecddcc14312aa6"

    # When updating this resource, use the tag that matches the GStreamer version.
    resource "rs" do
      url "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/gstreamer-1.24.7/gst-plugins-rs-gstreamer-1.24.7.tar.bz2"
      sha256 "0d499a6854920c31034587bbbabbddbf8b3949387ceb615749a80998da9d440f"

      # Backport support for newer `dav1d`
      # upstream commit ref, https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/commit/7e1ab086de00125bc0d596f9ec5d74c9b82b2cc0
      patch do
        url "https://raw.githubusercontent.com/Homebrew/formula-patches/6fff2c4c62f1fb32b5ade46ec9246fc239935d7a/gstreamer/gst-plugins-rs-dav1d.patch"
        sha256 "d17677a523af021b226969937550f19151b8042f6962eae9fa39ee0e0fc0fe3a"
      end
    end

    # Backport fix for build of gst-plugins-rs when using uninstalled pkgconfig files
    patch do
      url "https://gitlab.freedesktop.org/gstreamer/gstreamer/-/commit/6ce72488face35277643d3781d3da7c4f95d5e1e.diff"
      sha256 "e8526ba4da7a92904a0e55608bacb3ca823f60c398a922877b5945f65c5ddbfb"
    end
  end

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gstreamer/"
    regex(/href=.*?gstreamer[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "9d246b779b36a42346004b290306cfc47e7d5ededc0d9d999579fd6d6d61d04a"
    sha256 arm64_ventura:  "70ef869e83ab51ab6ce41ad6dc0e25e45feb35212a1d1be8824452f719d26ba9"
    sha256 arm64_monterey: "cd4f6f35e5c7106882f96a1b77c89ad5a80da324845bc097ce454cb68b2b3797"
    sha256 sonoma:         "d2340cb25e37bf8ae84711ed43371bbfa26d7c703e0a4f49db339e9407a54c31"
    sha256 ventura:        "1f2cb4177eaa2ac93b3e587a6a4ccc8436caf2c6eb39dd002bc69200b29fac6a"
    sha256 monterey:       "66efa6fbcfff8e0411e68c451b4273ae735e5f03686a854cb4650df0206f8a88"
    sha256 x86_64_linux:   "6c8884c463bc4e9cdb5cc0e3cadbd2695ea24df7beeddd65a7d4284213c0230e"
  end

  head do
    url "https://gitlab.freedesktop.org/gstreamer/gstreamer.git", branch: "main"

    resource "rs" do
      url "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs.git", branch: "main"
    end
  end

  depends_on "bison" => :build
  depends_on "cargo-c" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "aom"
  depends_on "cairo"
  depends_on "dav1d"
  depends_on "faac"
  depends_on "faad2"
  depends_on "fdk-aac"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk+3"
  depends_on "gtk4"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "json-glib"
  depends_on "lame"
  depends_on "libass"
  depends_on "libnice"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libshout"
  depends_on "libsndfile"
  depends_on "libsodium"
  depends_on "libsoup" # no linkage on Linux as dlopen'd
  depends_on "libusrsctp"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on "libxi"
  depends_on "libxtst"
  depends_on "little-cms2"
  depends_on "mpg123"
  depends_on "nettle"
  depends_on "opencore-amr"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "openssl@3"
  depends_on "opus"
  depends_on "orc"
  depends_on "pango"
  depends_on "pygobject3"
  depends_on "python@3.12"
  depends_on "rtmpdump"
  depends_on "speex"
  depends_on "srt"
  depends_on "srtp"
  depends_on "svt-av1"
  depends_on "taglib"
  depends_on "theora"
  depends_on "webp"
  depends_on "x264"
  depends_on "x265"

  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
    # musepack is not bottled on Linux
    # https://github.com/Homebrew/homebrew-core/pull/92041
    depends_on "musepack"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libdrm"
    depends_on "libva"
    depends_on "libxdamage"
    depends_on "libxv"
    depends_on "mesa"
    depends_on "pulseaudio"
    depends_on "wayland"
  end

  def python3
    which("python3.12")
  end

  # These paths used to live in various `gst-*` formulae.
  link_overwrite "bin/gst-*", "lib/ligst*", "lib/libges*", "lib/girepository-1.0/Gst*-1.0.typelib"
  link_overwrite "lib/girepository-1.0/GES-1.0.typelib", "lib/gst-validate-launcher/*", "lib/gstreamer-1.0/*"
  link_overwrite "lib/pkgconfig/gst*.pc", "lib/python3.12/site-packages/gi/overrides/*", "include/gstreamer-1.0/*"
  link_overwrite "share/gir-1.0/Gst*.gir", "share/gir-1.0/GES-1.0.gir", "share/gstreamer-1.0/*"
  link_overwrite "share/locale/*/LC_MESSAGES/gst-*.mo", "share/man/man1/g*"

  # Avoid overlinking of `gst-python` python extension module.
  # https://gitlab.freedesktop.org/gstreamer/gst-python/-/merge_requests/41
  # TODO: Migrate patch to gstreamer monorepo.
  patch :DATA

  def install
    odie "rs resource needs to be updated" if build.stable? && version != resource("rs").version

    (buildpath/"subprojects/gst-plugins-rs").install resource("rs")

    site_packages = Language::Python.site_packages(python3)
    # To pass arguments to subprojects (e.g. `gst-editing-services`), use
    #   -Dsubproject:option=value
    args = %W[
      -Dpython.platlibdir=#{site_packages}
      -Dpython.purelibdir=#{site_packages}
      -Dpython=enabled
      -Dlibav=enabled
      -Dlibnice=enabled
      -Dbase=enabled
      -Dgood=enabled
      -Dugly=enabled
      -Dbad=enabled
      -Ddevtools=enabled
      -Dges=enabled
      -Drtsp_server=enabled
      -Drs=enabled
      -Dtls=enabled
      -Dqt5=disabled
      -Dtools=enabled
      -Dorc-source=system
      -Dgpl=enabled
      -Dtests=disabled
      -Dexamples=disabled
      -Dnls=enabled
      -Dorc=enabled
      -Ddoc=disabled
      -Dgtk_doc=disabled
      -Dintrospection=enabled
      -Dpackage-origin=#{tap.default_remote}
      -Dgst-devtools:validate=enabled
      -Dgst-devtools:cairo=enabled
      -Dgst-editing-services:pygi-overrides-dir=#{site_packages}/gi/overrides
      -Dgst-python:pygi-overrides-dir=#{site_packages}/gi/overrides
      -Dgst-python:python=#{python3}
      -Dgst-plugins-bad:opencv=disabled
      -Dgst-plugins-bad:sctp=enabled
      -Dgst-plugins-bad:sctp-internal-usrsctp=disabled
      -Dgst-plugins-bad:webrtc=enabled
      -Dgst-plugins-good:soup=enabled
      -Dgst-plugins-rs:closedcaption=enabled
      -Dgst-plugins-rs:dav1d=enabled
      -Dgst-plugins-rs:sodium=enabled
      -Dgst-plugins-rs:csound=disabled
      -Dgst-plugins-rs:gtk4=enabled
      -Dgst-plugins-rs:sodium-source=system
    ]

    # The apple media plug-in uses API that was added in Mojave
    args << "-Dgst-plugins-bad:applemedia=disabled" if OS.mac? && MacOS.version <= :high_sierra

    # Ban trying to chown to root.
    # https://bugzilla.gnome.org/show_bug.cgi?id=750367
    args << "-Dgstreamer:ptp-helper-permissions=none"

    # Prevent the build from downloading an x86-64 version of bison.
    args << "-Dbuild-tools-source=system"

    # Set `RPATH` since `cargo-c` doesn't seem to.
    # https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/issues/279
    plugin_dir = lib/"gstreamer-1.0"
    rpath_args = [loader_path, rpath(source: plugin_dir)].map { |path| "-rpath,#{path}" }
    ENV["RUSTFLAGS"] = "--codegen link-args=-Wl,#{rpath_args.join(",")}"
    inreplace "subprojects/gst-plugins-rs/cargo_wrapper.py",
              "env['RUSTFLAGS'] = shlex_join(rust_flags)",
              "env['RUSTFLAGS'] = ' '.join(rust_flags)"

    # Make sure the `openssl-sys` crate uses our OpenSSL.
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def caveats
    <<~EOS
      All gst-* GStreamer plugins are now bundled in this formula.
      For GStreamer to find your own plugins, add their paths to `GST_PLUGIN_PATH`.
      For example, if you have plugins in `~/.local/lib/gstreamer-1.0`:
        export GST_PLUGIN_PATH="~/.local/lib/gstreamer-1.0"

      Do not install plugins into GStreamer's prefix. They will be deleted
      by `brew upgrade`.
    EOS
  end

  test do
    # TODO: Improve test according to suggestions at
    #   https://github.com/orgs/Homebrew/discussions/3740
    system bin/"gst-validate-launcher", "--usage"

    system python3, "-c", <<~EOS
      import gi
      gi.require_version('Gst', '1.0')
      from gi.repository import Gst
      print (Gst.Fraction(num=3, denom=5))
    EOS

    # FIXME: The initial plugin load takes a long time without extra permissions on
    # macOS, which frequently causes the slower Intel macOS runners to time out.
    # Need to allow a longer timeout or see if CI terminal can be made a developer tool.
    #
    # Ref: https://gitlab.freedesktop.org/gstreamer/gstreamer/-/issues/1119
    skip_plugins = OS.mac? && Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    ENV["GST_PLUGIN_SYSTEM_PATH"] = testpath if skip_plugins

    assert_match(/^Total count: \d+ plugin/, shell_output(bin/"gst-inspect-1.0"))
    return if skip_plugins

    system bin/"ges-launch-1.0", "--ges-version"
    system bin/"gst-inspect-1.0", "libav"
    system bin/"gst-inspect-1.0", "--plugin", "dvbsuboverlay"
    system bin/"gst-inspect-1.0", "--plugin", "fdkaac"
    system bin/"gst-inspect-1.0", "--plugin", "volume"
    system bin/"gst-inspect-1.0", "--plugin", "cairo"
    system bin/"gst-inspect-1.0", "--plugin", "dvdsub"
    system bin/"gst-inspect-1.0", "--plugin", "x264"
    system bin/"gst-inspect-1.0", "--plugin", "rtspclientsink"
    system bin/"gst-inspect-1.0", "--plugin", "rsfile"
    system bin/"gst-inspect-1.0", "--plugin", "nice"
    system bin/"gst-inspect-1.0", "--plugin", "webrtc"
    system bin/"gst-inspect-1.0", "hlsdemux2"
  end
end

__END__
diff --git a/subprojects/gst-python/gi/overrides/meson.build b/subprojects/gst-python/gi/overrides/meson.build
index 20aeb06ac9..3c53eab6d7 100644
--- a/subprojects/gst-python/gi/overrides/meson.build
+++ b/subprojects/gst-python/gi/overrides/meson.build
@@ -7,8 +7,10 @@ python.install_sources(pysources,
 host_system = host_machine.system()
 if host_system == 'windows'
   gst_dep_for_gi = gst_dep
+  python_ext_dep = python_dep
 else
   gst_dep_for_gi = gst_dep.partial_dependency(compile_args: true, includes: true, sources: true)
+  python_ext_dep = python_dep.partial_dependency(compile_args: true)
 endif

 gstpython = python.extension_module('_gi_gst',
@@ -17,7 +19,7 @@ gstpython = python.extension_module('_gi_gst',
     install_dir : pygi_override_dir,
     install_tag: 'python-runtime',
     include_directories : [configinc],
-    dependencies : [gst_dep_for_gi, python_dep, pygobject_dep],
+    dependencies : [gst_dep_for_gi, python_ext_dep, pygobject_dep],
 )

 env = environment()
