class Gstreamer < Formula
  desc "Development framework for multimedia applications"
  homepage "https://gstreamer.freedesktop.org/"
  license all_of: ["LGPL-2.0-or-later", "LGPL-2.1-or-later", "MIT"]

  stable do
    url "https://gitlab.freedesktop.org/gstreamer/gstreamer/-/archive/1.26.1/gstreamer-1.26.1.tar.bz2"
    sha256 "4ef9885d3e1e366ba6400e5bbc39228cf1ee3619cbc5c17295b86901879c105f"

    # When updating this resource, use the tag that matches the GStreamer version.
    resource "rs" do
      url "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/gstreamer-1.26.1/gst-plugins-rs-gstreamer-1.26.1.tar.bz2"
      sha256 "a3a65363cb5addc87918eb56e837740f077842ef95d0db2296159a0cad3523f8"

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
    sha256 arm64_sequoia: "ed81e3cb4bc2dc80f6cd7e0200df0a9de9c6ff610ceec01bef615a4813d47fb2"
    sha256 arm64_sonoma:  "ac317c901604ed40ff2c366ad0072dd17146273af06d5246b4fb12f5ae9c71f7"
    sha256 arm64_ventura: "f6f7249e9298afab0c420b9d508fb057eda61e444666adec2153cbd94af3d57d"
    sha256 sonoma:        "b66228ea4e50d15ee1767a59ef374bdeff5aadb5806669dfae5b00a6205d105f"
    sha256 ventura:       "6bf802620b0b5d00379407b695fad4bb61c1f14449a9c8cd16cd3d9742be84c4"
    sha256 arm64_linux:   "83b6b8e873f8218902efe7b67a0e2153df109879762774d8e66a860cfd92072e"
    sha256 x86_64_linux:  "69ab9ecce839e04132c3903022de3372763474182f198a70b677b7a64f373d8f"
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
  depends_on "pkgconf" => :build
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
  depends_on "python@3.13"
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
    which("python3.13")
  end

  # These paths used to live in various `gst-*` formulae.
  link_overwrite "bin/gst-*", "lib/ligst*", "lib/libges*", "lib/girepository-1.0/Gst*-1.0.typelib"
  link_overwrite "lib/girepository-1.0/GES-1.0.typelib", "lib/gst-validate-launcher/*", "lib/gstreamer-1.0/*"
  link_overwrite "lib/pkgconfig/gst*.pc", "lib/python3.13/site-packages/gi/overrides/*", "include/gstreamer-1.0/*"
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
      -Dgst-plugins-bad:opencv=disabled
      -Dgst-plugins-bad:sctp=enabled
      -Dgst-plugins-bad:sctp-internal-usrsctp=disabled
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
    ENV.append "RUSTFLAGS", "--codegen link-args=-Wl,#{rpath_args.join(",")}"

    # On Linux, adjust processing of RUSTFLAGS to avoid using shlex, which may mangle our
    # RPATH-related flags, due to the presence of `$` in $ORIGIN.
    if OS.linux?
      wrapper_files = %w[
        subprojects/gst-plugins-rs/cargo_wrapper.py
        subprojects/gst-devtools/dots-viewer/cargo_wrapper.py
      ]
      inreplace wrapper_files do |s|
        s.gsub!(/shlex\.split\(env\.get\(("RUSTFLAGS"|'RUSTFLAGS'), (""|'')\)\)/,
                "' '.split(env.get(\"RUSTFLAGS\", \"\"))")
        s.gsub! "shlex_join(rust_flags)", "' '.join(rust_flags)"
      end
    end

    # Make sure the `openssl-sys` crate uses our OpenSSL.
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    # Support finding the `libnice` plugin, which is in a separate formula.
    # Needs to be done in `post_install`, since bottling prunes this symlink.
    libnice_gst_plugin = Formula["libnice-gstreamer"].opt_libexec/"gstreamer-1.0"/shared_library("libgstnice")
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

    system python3, "-c", <<~PYTHON
      import gi
      gi.require_version('Gst', '1.0')
      from gi.repository import Gst
      print (Gst.Fraction(num=3, denom=5))
    PYTHON

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
    system bin/"gst-inspect-1.0", "hlsdemux2"
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
