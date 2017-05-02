class GstPluginsUglyAT010 < Formula
  desc "GStreamer plugins (possibly problematic for distributors)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-0.10.19.tar.bz2"
  sha256 "1ca90059275c0f5dca71d4d1601a8f429b7852baed0723e820703b977e2c8df0"

  bottle do
    sha256 "333c70ada40a6a998b528d8e053d2ad7563a76f94b43302d608483c0a1e0b8dd" => :sierra
    sha256 "57670ee8e35998b12758f0ab25b0e7e4d1c0ee4971c5a102b2945c6fda66ed46" => :el_capitan
    sha256 "6b808ae9de72d26b178279e6d38711a7e4d869ca0de1e456de4424eaea009693" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base@0.10"

  # The set of optional dependencies is based on the intersection of
  # gst-plugins-ugly-0.10.17/REQUIREMENTS and Homebrew formulae
  depends_on "dirac" => :optional
  depends_on "mad" => :optional
  depends_on "jpeg" => :optional
  depends_on "libvorbis" => :optional
  depends_on "cdparanoia" => :optional
  depends_on "lame" => :optional
  depends_on "two-lame" => :optional
  depends_on "libshout" => :optional
  depends_on "aalib" => :optional
  depends_on "libcaca" => :optional
  depends_on "libdvdread" => :optional
  depends_on "sdl" => :optional
  depends_on "libmpeg2" => :optional
  depends_on "a52dec" => :optional
  depends_on "liboil" => :optional
  depends_on "flac" => :optional
  depends_on "gtk+" => :optional
  depends_on "pango" => :optional
  depends_on "theora" => :optional
  depends_on "libmms" => :optional
  depends_on "x264" => :optional
  depends_on "opencore-amr" => :optional
  # Does not work with libcdio 0.9

  def install
    ENV.append "CFLAGS", "-no-cpp-precomp -funroll-loops -fstrict-aliasing"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    if build.with? "opencore-amr"
      # Fixes build error, missing includes.
      # https://github.com/mxcl/homebrew/issues/14078
      nbcflags = `pkg-config --cflags opencore-amrnb`.chomp
      wbcflags = `pkg-config --cflags opencore-amrwb`.chomp
      ENV["AMRNB_CFLAGS"] = nbcflags + "-I#{HOMEBREW_PREFIX}/include/opencore-amrnb"
      ENV["AMRWB_CFLAGS"] = wbcflags + "-I#{HOMEBREW_PREFIX}/include/opencore-amrwb"
    else
      args << "--disable-amrnb" << "--disable-amrwb"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    gst = Formula["gstreamer@0.10"].opt_bin/"gst-inspect-0.10"
    output = shell_output("#{gst} --plugin dvdsub")
    assert_match version.to_s, output
  end
end
