class Cattle < Formula
  desc "Brainfuck language toolkit"
  homepage "https://github.com/andreabolognani/cattle"
  url "https://kiyuko.org/software/cattle/releases/cattle-1.4.0.tar.xz"
  sha256 "9ba2d746f940978b5bfc6c39570dde7dc55d5b4d09d0d25f29252d6a25fb562f"

  bottle do
    sha256 "351e447fdd9020945375ad5db0884e1f4f80915d4af4911cfebd37636afd2fe6" => :catalina
    sha256 "0ae9acb42c85b12815f16e0325bdca644a7df6a6d52734e8f713f5d38b20c480" => :mojave
    sha256 "db653a4f8e8463ced42f6b9aaad04f8f09fff9847225054f4833ac06e1a03bfe" => :high_sierra
    sha256 "1d66b604d5ae66b79d83ac63b959ca37df121dd146be43a6af8fb110c6ae196b" => :sierra
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
