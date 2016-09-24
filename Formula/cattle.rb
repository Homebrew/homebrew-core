class Cattle < Formula
  desc "Brainfuck language toolkit"
  homepage "https://github.com/andreabolognani/cattle"
  # Source archive tarball results in "./ChangeLog: No such file or directory"
  # Reported 12 Sep 2016 https://github.com/andreabolognani/cattle/issues/4
  url "https://github.com/andreabolognani/cattle.git",
      :tag => "cattle-1.2.1",
      :revision => "338a34f7abc35334afd378f305c6e1fb0d0abd7d"
  head "https://github.com/andreabolognani/cattle.git"

  bottle do
    sha256 "724e4f89fb7b7ea2f2f31594d036e5a8a4932d78374e1f08ab91b7d0ed2e37dc" => :el_capitan
    sha256 "7c507fd0f0e3c175ad6c3ac6656e61195512cb88d25412ca7332748ac6872d25" => :yosemite
    sha256 "93bea5bb1f99a9ec84a3ddc2bbe752cc9fd7627b6f099ac54fadc3150405749b" => :mavericks
  end

  depends_on "gtk-doc" => :build
  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    pkgshare.mkpath
    cp_r ["examples", "tests"], pkgshare
    rm Dir["#{pkgshare}/{examples,tests}/{Makefile.am,.gitignore}"]

    inreplace "autogen.sh", "libtoolize", "glibtoolize"
    system "sh", "autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    cp_r (pkgshare/"examples").children, testpath
    cp_r (pkgshare/"tests").children, testpath
    system ENV.cc, "common.c", "run.c", "-o", "test",
           "-I#{include}/cattle-1.0",
           "-I#{Formula["glib"].include}/glib-2.0",
           "-I#{Formula["glib"].lib}/glib-2.0/include",
           "-L#{lib}",
           "-L#{Formula["glib"].lib}",
           "-lcattle-1.0", "-lglib-2.0", "-lgio-2.0", "-lgobject-2.0"
    assert_match "Unbalanced brackets", shell_output("./test program.c 2>&1", 1)
  end
end
