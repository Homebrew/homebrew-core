class Cattle < Formula
  desc "Brainfuck language toolkit"
  homepage "https://github.com/andreabolognani/cattle"
  url "https://kiyuko.org/software/cattle/releases/cattle-1.2.2.tar.gz"
  sha256 "e8e9baba41c4b25a1fdac552c5b03ad62a4dbb782e9866df3c3463baf6411826"
  revision 1

  bottle do
    sha256 "9fe38957085b82d4f32b8301a4541b7f66400d27677b38852f81f7e0b7dbc497" => :mojave
    sha256 "957d2f936937bd3682063bc0e7386b22ade2ee3398ad8ad29700bf395f2bc4f4" => :high_sierra
    sha256 "6387555e1f0f6804d9d9d967af83c370129d3fc7b4f8644b41b50a6d7b10baf9" => :sierra
    sha256 "42652ee8648cb83d278d274b149c644f9785a13c281edcd8d9dab9baf293da33" => :el_capitan
  end

  head do
    url "https://github.com/andreabolognani/cattle.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

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
