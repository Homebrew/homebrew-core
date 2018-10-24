class GnuSmalltalk < Formula
  desc "GNU Smalltalk interpreter and image"
  homepage "http://smalltalk.gnu.org/"
  url "https://ftp.gnu.org/gnu/smalltalk/smalltalk-3.2.5.tar.xz"
  mirror "https://ftpmirror.gnu.org/smalltalk/smalltalk-3.2.5.tar.xz"
  sha256 "819a15f7ba8a1b55f5f60b9c9a58badd6f6153b3f987b70e7b167e7755d65acc"
  revision 7
  head "https://github.com/gnu-smalltalk/smalltalk.git"

  bottle do
    sha256 "94385e9ceb6dac590be88af2d0de7a196d3491747f3772c2aa2f92620ea111db" => :mojave
    sha256 "9d086ae46e600651c937a8602fbb3a2c1fbe44be15517fe210dd46d21d7a391c" => :high_sierra
    sha256 "593a5202fc714257dc5ffb0fcad4faa553d63727f74d87a3106eaf6dcae46464" => :sierra
    sha256 "a2a098e2fd4e07d87b705fc8aaabb6603df62ac437b5af68f610ff5b4797c0d5" => :el_capitan
  end

  option "with-tcltk", "Build the Tcl/Tk module that requires X11"

  deprecated_option "tcltk" => "with-tcltk"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gawk" => :build
  depends_on "pkg-config" => :build
  depends_on "gdbm"
  depends_on "gnutls"
  depends_on "libffi"
  depends_on "libsigsegv"
  depends_on "libtool"
  depends_on "readline"
  depends_on :x11 if build.with? "tcltk"
  depends_on "glew" => :optional

  def install
    ENV.m32 unless MacOS.prefer_64_bit?

    # Fix build failure "Symbol not found: _clock_gettime"
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      ENV["ac_cv_search_clock_gettime"] = "no"
    end

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-lispdir=#{elisp}
      --disable-gtk
      --with-readline=#{Formula["readline"].opt_lib}
    ]

    if build.without? "tcltk"
      args << "--without-tcl" << "--without-tk" << "--without-x"
    end

    # Disable generational gc in 32-bit
    args << "--disable-generational-gc" unless MacOS.prefer_64_bit?

    system "autoreconf", "-ivf"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    path = testpath/"test.gst"
    path.write "0 to: 9 do: [ :n | n display ]\n"

    assert_match "0123456789", shell_output("#{bin}/gst #{path}")
  end
end
