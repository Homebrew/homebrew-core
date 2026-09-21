class Gstreamer < Formula
  desc "Development framework for multimedia applications"
  homepage "https://gstreamer.freedesktop.org/"
  license all_of: ["LGPL-2.0-or-later", "LGPL-2.1-or-later", "MIT"]
  compatibility_version 1

  stable do
    url "https://gitlab.freedesktop.org/gstreamer/gstreamer/-/archive/1.28.7/gstreamer-1.28.7.tar.bz2"
    sha256 "4aabbbf88837a592d425c592c852c577359df65f62c2f58d57db7695d6ebbaa8"

    # When updating this resource, use the tag that matches the GStreamer version.
    resource "rs" do
      url "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/gstreamer-1.28.7/gst-plugins-rs-gstreamer-1.28.7.tar.bz2"
      sha256 "d5acc3e2cd92f09ccfefa357905758274b205ce9b3521ab1d88dbb4072a25f21"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gstreamer/"
    regex(/href=.*?gstreamer[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "d3d5e9fd43776adfbbd36cdb36dd3d7e82cb4ee133f4cd3096bbc3bab7ff5e1c"
    sha256 arm64_tahoe:       "e0d0a7e8224cd9d3374671fda5b03fd36468382211d1e261a305813739674f85"
    sha256 arm64_sequoia:     "a70c8499dcef3b7f5cb588797754d437a05ff0e440eac3ef07a01ba57fe4be32"
    sha256 arm64_linux:       "1e7eda59cbe6ae72ec18d5674b73a910d79e0d3717d56858c70a204da4e97c8e"
    sha256 x86_64_linux:      "7a3cabf13bd1005dccb1a470fea2ac685dafa61b1e5303b3ba1fadba3f9109ae"
  end

  head do
    url "https://gitlab.freedesktop.org/gstreamer/gstreamer.git", branch: "main"

    resource "rs" do
      url "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs.git", branch: "main"
    end
  end

  depends_on "bison" => :build
  depends_on "cargo-c" => :build
  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "aom"
  depends_on "cairo"
  depends_on "dav1d"
  depends_on "faac"
  depends_on "faad2"
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
  depends_on "librsvg"
  depends_on "libshout"
  depends_on "libsndfile"
  depends_on "libsodium"
  depends_on "libsoup" => :no_linkage # dlopen'd
  depends_on "libusrsctp"
  depends_on "libvmaf"
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
  depends_on "pygobject3" => :no_linkage
  depends_on "python@3.14"
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

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
    # musepack is not bottled on Linux
    # https://github.com/Homebrew/homebrew-core/pull/92041
    depends_on "musepack"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "elfutils" => :no_linkage
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "libdrm"
    depends_on "libva"
    depends_on "libxdamage"
    depends_on "libxv"
    depends_on "mesa"
    depends_on "pulseaudio"
    depends_on "wayland"
    depends_on "zlib-ng-compat"
  end

  on_intel do
    depends_on "nasm" => :build
  end

  skip_clean "lib/gstreamer-1.0/libgstnice.dylib", "lib/gstreamer-1.0/libgstnice.so"

  # These paths used to live in various `gst-*` formulae.
  link_overwrite "bin/gst-*", "lib/ligst*", "lib/libges*", "lib/girepository-1.0/Gst*-1.0.typelib"
  link_overwrite "lib/girepository-1.0/GES-1.0.typelib", "lib/gst-validate-launcher/*", "lib/gstreamer-1.0/*"
  link_overwrite "lib/pkgconfig/gst*.pc", "lib/python3.14/site-packages/gi/overrides/*", "include/gstreamer-1.0/*"
  link_overwrite "share/gir-1.0/Gst*.gir", "share/gir-1.0/GES-1.0.gir", "share/gstreamer-1.0/*"
  link_overwrite "share/locale/*/LC_MESSAGES/gst-*.mo", "share/man/man1/g*"

  # Support faac 2.0 API
  patch do
    url "https://gitlab.freedesktop.org/gstreamer/gstreamer/-/commit/49b4b4129e3b488f246493d3a57dc70652ec9dcf.diff"
    sha256 "25ef9fc417878e0aac46ffb0f16c5a5d1a44341cd3364c97111980fb5bfd64b8"
    type :unofficial
    resolves "https://gitlab.freedesktop.org/gstreamer/gstreamer/-/merge_requests/12148"
  end

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
      -Dlibnice=disabled
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
      -Dgst-plugins-bad:fdkaac=disabled
      -Dgst-plugins-bad:opencv=disabled
      -Dgst-plugins-bad:sctp=enabled
      -Dgst-plugins-bad:sctp-internal-usrsctp=disabled
      -Dgst-plugins-good:soup=enabled
      -Dgst-plugins-rs:closedcaption=enabled
      -Dgst-plugins-rs:dav1d=enabled
      -Dgst-plugins-rs:sodium=enabled
      -Dgst-plugins-rs:csound=disabled
      -Dgst-plugins-rs:gtk4=enabled
      -Dgst-plugins-rs:webrtchttp=enabled
      -Dgst-plugins-rs:sodium-source=system
    ]

    # Ban trying to chown to root.
    # https://bugzilla.gnome.org/show_bug.cgi?id=750367
    args << "-Dgstreamer:ptp-helper-permissions=none"

    # Prevent the build from downloading an x86-64 version of bison.
    args << "-Dbuild-tools-source=system"

    # TODO: Remove when gst-plugin-whisper builds on Linux arm64 again.
    # Whisper was added in 1.28.1 and currently fails in CI with Rust type
    # mismatches (*const i8 vs *const u8).
    # Ref: https://gstreamer.freedesktop.org/releases/1.28/#1.28.1
    args << "-Dgst-plugins-rs:whisper=disabled" if OS.linux? && Hardware::CPU.arm?

    # Set `RPATH` since `cargo-c` doesn't seem to.
    # https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/issues/279
    plugin_dir = lib/"gstreamer-1.0"
    rpaths = [loader_path, rpath(source: plugin_dir), rpath(source: plugin_dir/"validate")]
    rpath_args = rpaths.map { |path| "-rpath,#{path}" }
    ENV.append_to_rustflags "--codegen link-args=-Wl,#{rpath_args.join(",")}"

    # Make sure the `openssl-sys` crate uses our OpenSSL.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # Support finding the `libnice` plugin, which is in a separate formula.
    libnice_gst_plugin = formula_opt_libexec("libnice-gstreamer")/"gstreamer-1.0"/shared_library("libgstnice")
    gst_plugin_dir = lib/"gstreamer-1.0"
    ln_sf libnice_gst_plugin.relative_path_from(gst_plugin_dir), gst_plugin_dir
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

    # The macOS command-line tools start NSApplication even for plugin inspection.
    system python3, "-c", <<~PYTHON
      import gi
      gi.require_version('Gst', '1.0')
      gi.require_version('GES', '1.0')
      from gi.repository import GES, Gst
      print (Gst.Fraction(num=3, denom=5))
      print (GES.version())
      Gst.init(None)
      assert Gst.Registry.get().get_plugin_list()
      for plugin in ["libav", "dvbsuboverlay", "volume", "cairo", "dvdsub", "x264", "rtspclientsink", "rsfile"]:
          assert Gst.Plugin.load_by_name(plugin), plugin
      assert Gst.ElementFactory.make("hlsdemux2", None)
    PYTHON
  end
end

__END__
diff --git a/subprojects/gst-python/gi/overrides/meson.build b/subprojects/gst-python/gi/overrides/meson.build
index 20aeb06ac9..3c53eab6d7 100644
--- a/subprojects/gst-python/gi/overrides/meson.build
+++ b/subprojects/gst-python/gi/overrides/meson.build
@@ -7,9 +7,11 @@ python.install_sources(pysources,
 host_system = host_machine.system()
 if host_system == 'windows'
   gst_dep_for_gi = gst_dep
+  python_ext_dep = python_dep
 else
   gst_dep_for_gi = gst_dep.partial_dependency(compile_args: true, includes: true, sources: true)
   gstanalytics_dep_for_gi = gstbad_dep.partial_dependency(compile_args:true, includes:true, sources:true)
+  python_ext_dep = python_dep.partial_dependency(compile_args: true)
 endif

 gstpython = python.extension_module('_gi_gst',
@@ -18,7 +20,7 @@ gstpython = python.extension_module('_gi_gst',
     install_dir : pygi_override_dir,
     install_tag: 'python-runtime',
     include_directories : [configinc],
-    dependencies : [gst_dep_for_gi, python_dep, pygobject_dep],
+    dependencies : [gst_dep_for_gi, python_ext_dep, pygobject_dep],
 )

 env = environment()
