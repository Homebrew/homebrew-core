class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.28.1.tar.xz"
  sha256 "84cf6145f9cc82bfff690005be24392c8f3c52f8e00ff04d8eea371429c09424"
  license all_of: ["GPL-2.0-only", "LGPL-2.1-only", "BSD-2-Clause", "FTL", "zlib-acknowledgement"]
  revision 3

  livecheck do
    url "https://download.enlightenment.org/rel/libs/efl/"
    regex(/href=.*?efl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "889efed8a97104e156fe8ad7d90fd0a731bbeb4dac72b3fa65069b138474a160"
    sha256 arm64_tahoe:       "d2242b482406cdda474ae53894167b08f0c9e0345fdc50b6ad3b0891fd49d4dc"
    sha256 arm64_sequoia:     "37327b3f19bb2e83606a6181581b525b8b921c458f8338c4a42032096d8665fe"
    sha256 arm64_sonoma:      "e4bc6b982f812f73f1a72a33d2cd44cb0e2d1e8151e5f4e80fc2f69dffdb5f7e"
    sha256 sonoma:            "c69495ceac0e9dcf5986ebdd1908da0052fe628a005338e65d392422936f7d41"
    sha256 arm64_linux:       "602cdcf9532c25b04eb3fe1467e3b3b8a9a4529961ac6c3d631a64fdb702a15b"
    sha256 x86_64_linux:      "27a691839e076fe9bd8b88aa671e44d4d80c07991205e0cb4bd791eb05b9e4b5"
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
  depends_on "openssl@3"
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

  # Fix conflicting bool definition.
  patch do
    url "https://github.com/Enlightenment/efl/commit/0fcaf460c4a33eb54a51b9d8cb38321603019529.patch?full_index=1"
    sha256 "1336cb9bcfbaf644b1ab34baeedaa66fef0118855b4c3bc860d368ed05860a6a"
    type :backport
    resolves "https://git.enlightenment.org/enlightenment/efl/issues/84"
  end
  patch do
    url "https://github.com/Enlightenment/efl/commit/628c40cce2de0a18818b40615d3351b0c9e9b889.patch?full_index=1"
    sha256 "9c6149e3f0b322bce621c60ff15563b1b5a3c5ed29465f2fe965ca9af5346d53"
    type :backport
  end

  # Remove LuaJIT 2.0 linker args -pagezero_size and -image_base
  # to fix ARM build using LuaJIT 2.1+
  patch do
    url "https://github.com/Enlightenment/efl/commit/0c4f145ca20905d53cca75b5d2ccc15e4261483d.patch?full_index=1"
    sha256 "5cef6fea74ece27d5abc78f4d8975817ca398c6390c929b4f9549fcaddebfef9"
    type :backport
  end

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
      -Dsystemd=false
      -Dv4l2=false
      -Dx11=false
      -Dlua-interpreter=luajit
    ]
    args << "-Dcocoa=true" if OS.mac?

    # Install in our Cellar - not dbus's
    inreplace "dbus-services/meson.build", "dep.get_pkgconfig_variable('session_bus_services_dir')",
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
