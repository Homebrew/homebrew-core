class GstPluginsUgly < Formula
  desc "GStreamer plugins (well-supported, possibly problematic for distributors)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.8.2.tar.xz"
  sha256 "9c5b33a2a98fc1d6d6c99a1b536b1fb2de45f53cc8bf8ab85a8b8141fed1a8ac"

  bottle do
    sha256 "63e208a652c56f960037d91784dc0e1a667c9d9eb950e29ce8fc5ea1fab37f0e" => :el_capitan
    sha256 "d56823dd4712b60802531d4ed7e97509750ae68a7a6b6c4eb60803b9b218eda8" => :yosemite
    sha256 "d835ee3c460cf60e1f8bd8fc3e88213d5f69f0e20be4692c9f4c65bf22bc4fbe" => :mavericks
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
