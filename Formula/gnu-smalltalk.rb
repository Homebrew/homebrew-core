class GnuSmalltalk < Formula
  desc "GNU Smalltalk interpreter and image"
  homepage "http://smalltalk.gnu.org/"
  url "https://ftpmirror.gnu.org/smalltalk/smalltalk-3.2.5.tar.xz"
  mirror "https://ftp.gnu.org/gnu/smalltalk/smalltalk-3.2.5.tar.xz"
  sha256 "819a15f7ba8a1b55f5f60b9c9a58badd6f6153b3f987b70e7b167e7755d65acc"
  revision 3

  head "https://github.com/bonzini/smalltalk.git"

  bottle do
    sha256 "bb6f1d1b564752a8feaf40be0c9dcecf116339b210a583cfd859b7d91950a9a2" => :el_capitan
    sha256 "994b6c542d0c1a6913d0a30b9ae1429c9067faa85cdf483e8cf10a99a18d00d6" => :yosemite
    sha256 "4e7a90fc84d973a3b94f63e7b719b48ebe1905a2016d4f8dba5508f5b6d87cb2" => :mavericks
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
