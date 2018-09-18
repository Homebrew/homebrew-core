class GstPluginsUgly < Formula
  desc "Library for constructing graphs of media-handling components"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.14.3.tar.xz"
  sha256 "43847fc4d1eae26dd48a6a93d0460146f5f0802582a7e8a9cc66f09dcb0b2306"

  bottle do
    sha256 "46cc39665b41cd6e46d2c68eddcaa1888daf33954fcf5ec8a83c070e9f4c6d03" => :mojave
    sha256 "7878c28501220a493d75fa0c29ad6563b6219c8659914e2d1e4be905c6126450" => :high_sierra
    sha256 "dbc63b0a8bc0c244f098d1bbc25204b77c2725a3dcc0a77c4baf371856e667c1" => :sierra
    sha256 "a841c09a70c36550073c252a5e4c6d017401da21a61c967b739f374e229b8733" => :el_capitan
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-plugins-ugly.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"

  # The set of optional dependencies is based on the intersection of
  # gst-plugins-ugly-0.10.17/REQUIREMENTS and Homebrew formulae
  depends_on "jpeg" => :recommended
  depends_on "a52dec" => :optional
  depends_on "aalib" => :optional
  depends_on "cdparanoia" => :optional
  depends_on "dirac" => :optional
  depends_on "flac" => :optional
  depends_on "gtk+" => :optional
  depends_on "lame" => :optional
  depends_on "libcaca" => :optional
  depends_on "libdvdread" => :optional
  depends_on "libmms" => :optional
  depends_on "libmpeg2" => :optional
  depends_on "liboil" => :optional
  depends_on "libshout" => :optional
  depends_on "libvorbis" => :optional
  depends_on "mad" => :optional
  depends_on "opencore-amr" => :optional
  depends_on "pango" => :optional
  depends_on "theora" => :optional
  depends_on "two-lame" => :optional
  depends_on "x264" => :optional
  # Does not work with libcdio 0.9

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --disable-debug
      --disable-dependency-tracking
    ]

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    if build.with? "opencore-amr"
      # Fixes build error, missing includes.
      # https://github.com/Homebrew/homebrew/issues/14078
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
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin dvdsub")
    assert_match version.to_s, output
  end
end
