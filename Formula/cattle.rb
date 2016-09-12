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
    sha256 "556dfc01fb018724e71f891bb7f6694330772a9f7d266483a2f51b18038744a9" => :el_capitan
    sha256 "b646d326fa499931ae7ef731fa6fce4232239fce1d7f5b217b109ceafd784153" => :yosemite
    sha256 "4778f55a4ac08e5bf3f9402a37a5c6d97747ee16425325fa3a7fcda69034429d" => :mavericks
    sha256 "798aa25810d5dbfa2526cf0edf9117798b311c6ae6ce42b3a05c0bc90d087125" => :mountain_lion
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
