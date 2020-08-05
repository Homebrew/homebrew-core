class Cattle < Formula
  desc "Brainfuck language toolkit"
  homepage "https://kiyuko.org/software/cattle"
  url "https://kiyuko.org/software/cattle/releases/cattle-1.4.0.tar.xz"
  sha256 "9ba2d746f940978b5bfc6c39570dde7dc55d5b4d09d0d25f29252d6a25fb562f"

  bottle do
    sha256 "d721fea1c78f6b79eb7ae7e325442e276638919bdef0a21604e910501d4cc67f" => :catalina
    sha256 "7ce0b67200025300e8e326dc890c79b94be12b627ebc4bbf230ae64437aa286d" => :mojave
    sha256 "43b809e209b52621c0ac66810b751a22f43d1718f75f41c9c0364d6ecb762b83" => :high_sierra
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

    mkdir "build" do
      system "../configure", "--disable-dependency-tracking",
                             "--disable-silent-rules",
                             "--prefix=#{prefix}"
      system "make", "install"
    end
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
