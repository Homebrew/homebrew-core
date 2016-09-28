class GnuSmalltalk < Formula
  desc "GNU Smalltalk interpreter and image"
  homepage "http://smalltalk.gnu.org/"
  url "https://ftpmirror.gnu.org/smalltalk/smalltalk-3.2.5.tar.xz"
  mirror "https://ftp.gnu.org/gnu/smalltalk/smalltalk-3.2.5.tar.xz"
  sha256 "819a15f7ba8a1b55f5f60b9c9a58badd6f6153b3f987b70e7b167e7755d65acc"
  revision 5

  head "https://github.com/bonzini/smalltalk.git"

  bottle do
    sha256 "45c067640a3cd5e8453664e637f25e7e3205ebe4dfd5dcb609ea89a508dc14cf" => :sierra
    sha256 "7190b107e1211615b45a7168bd0a4b3fdf194f11764285e30ed90b22bfacc659" => :el_capitan
    sha256 "7f879a4dd647c3d3324154060aa4bbe62fb0b45d9b44cefceab8ffb2bdc1f49f" => :yosemite
  end

  devel do
    url "http://alpha.gnu.org/gnu/smalltalk/smalltalk-3.2.91.tar.gz"
    mirror "https://www.mirrorservice.org/sites/alpha.gnu.org/gnu/smalltalk/smalltalk-3.2.91.tar.gz"
    sha256 "13a7480553c182dbb8092bd4f215781b9ec871758d1db7045c2d8587e4d1bef9"
  end

  option "with-test", "Verify the build with make check (this may hang)"
  option "with-tcltk", "Build the Tcl/Tk module that requires X11"

  deprecated_option "tests" => "with-test"
  deprecated_option "with-tests" => "with-test"
  deprecated_option "tcltk" => "with-tcltk"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :run
  depends_on "pkg-config" => :build
  depends_on "gawk" => :build
  depends_on "readline"
  depends_on "gnutls"
  depends_on "gdbm"
  depends_on "libffi" => :recommended
  depends_on "libsigsegv" => :recommended
  depends_on "glew" => :optional
  depends_on :x11 if build.with? "tcltk"

  fails_with :llvm do
    build 2334
    cause "Codegen problems with LLVM"
  end

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

    # disable generational gc in 32-bit and if libsigsegv is absent
    if !MacOS.prefer_64_bit? || build.without?("libsigsegv")
      args << "--disable-generational-gc"
    end

    system "autoreconf", "-ivf"
    system "./configure", *args
    system "make"
    system "make", "-j1", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    path = testpath/"test.gst"
    path.write "0 to: 9 do: [ :n | n display ]\n"

    assert_match "0123456789", shell_output("#{bin}/gst #{path}")
  end
end
