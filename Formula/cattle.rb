class Cattle < Formula
  desc "Brainfuck language toolkit"
  homepage "https://kiyuko.org/software/cattle"
  url "https://kiyuko.org/software/cattle/releases/cattle-1.4.0.tar.xz"
  sha256 "9ba2d746f940978b5bfc6c39570dde7dc55d5b4d09d0d25f29252d6a25fb562f"
  license "GPL-2.0"

  bottle do
    sha256                               arm64_big_sur: "30cc03818912570ba2f48545b53a8217d2f8d0883e0308b55825d59aba1e342d"
    sha256                               big_sur:       "d6d17fed746c28274bd67416616df6ed87b7c6eae25593792d1ce815760458d3"
    sha256                               catalina:      "d721fea1c78f6b79eb7ae7e325442e276638919bdef0a21604e910501d4cc67f"
    sha256                               mojave:        "7ce0b67200025300e8e326dc890c79b94be12b627ebc4bbf230ae64437aa286d"
    sha256                               high_sierra:   "43b809e209b52621c0ac66810b751a22f43d1718f75f41c9c0364d6ecb762b83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cc3ad88464fb616899345d986acd64a8108ad271e4cc9d09370cd8055a1774f"
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
