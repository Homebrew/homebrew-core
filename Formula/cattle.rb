class Cattle < Formula
  desc "Brainfuck language toolkit"
  homepage "https://github.com/andreabolognani/cattle"
  url "http://kiyuko.org/software/cattle/releases/1.2.2/source"
  sha256 "e8e9baba41c4b25a1fdac552c5b03ad62a4dbb782e9866df3c3463baf6411826"

  bottle do
    sha256 "9155787316cc502e87a4f2f9fc96d0e68da0de47a125af4dd47dff0e409c9737" => :sierra
    sha256 "4db6aba09bf4b3fa6f59423b8d34f108e6a5d63d0338672e1bdcc305b8fdac67" => :el_capitan
    sha256 "0cd99db357d824c250d115146959c710ddd52a6fbb165308867d2b29c65c5c42" => :yosemite
  end

  head do
    url "https://github.com/andreabolognani/cattle.git"

    depends_on "gtk-doc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    pkgshare.mkpath
    cp_r ["examples", "tests"], pkgshare
    rm Dir["#{pkgshare}/{examples,tests}/{Makefile.am,.gitignore}"]

    if build.head?
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      system "sh", "autogen.sh"
    end
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
