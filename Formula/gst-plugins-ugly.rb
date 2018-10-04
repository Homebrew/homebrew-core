class GstPluginsUgly < Formula
  desc "Library for constructing graphs of media-handling components"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.14.4.tar.xz"
  sha256 "ac02d837f166c35ff6ce0738e281680d0b90052cfb1f0255dcf6aaca5f0f6d23"

  bottle do
    sha256 "f2a66569b4d7a6a5ca09c025b58bb18023d7867617c6c9a4bc8e39f042df92e1" => :mojave
    sha256 "e6b8371d2c5562f213dd4b5836a83edf220c6d8d19b4630d1f8faf4540bb9167" => :high_sierra
    sha256 "0231f4300eeea2d6d159c2d23c814e8e6e46b4bc491fb8cb6f05981637007bcd" => :sierra
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
