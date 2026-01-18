class Cattle < Formula
  desc "Brainfuck language toolkit"
  homepage "https://kiyuko.org/software/cattle"
  license "GPL-2.0-or-later"

  stable do
    url "https://kiyuko.org/software/cattle/releases/cattle-1.4.0.tar.xz"
    sha256 "9ba2d746f940978b5bfc6c39570dde7dc55d5b4d09d0d25f29252d6a25fb562f"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https://kiyuko.org/software/cattle/releases"
    regex(/href=.*?cattle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:    "e0a80736a4afb81659a8e8eaa4dee70a320bc7c8f7c756d14891c333f65748e6"
    sha256                               arm64_sequoia:  "502399f17e0777926e50b1a067eff9ff5520bcbf5457fb73156376891726d411"
    sha256                               arm64_sonoma:   "2e8272b2652bd83dda6c28b3b13464ef9adbd7f905bfa6a604e89bad92b5f652"
    sha256                               arm64_ventura:  "dbe7b8b3f8f215b8d73218e64e6f884b248da90095f2dc6ea8f73abf3db72f79"
    sha256                               arm64_monterey: "a8cfe837a78af532853dc6fefce95c2b11212e287640a3b527ca6e30a99e8edb"
    sha256                               arm64_big_sur:  "30cc03818912570ba2f48545b53a8217d2f8d0883e0308b55825d59aba1e342d"
    sha256                               sonoma:         "0b70e1d36468fdea6a86e9e35425d7d35298a448c79d4a8a92fb6b02fa28a1fc"
    sha256                               ventura:        "3ea680e66032aa529230bab1e7f3d63fe1fa49febb51b6f5629c09370bfff182"
    sha256                               monterey:       "f6367afe418e8a7715ef32fc386228aae672034e62b35f84ac7ebe7476cb88ff"
    sha256                               big_sur:        "d6d17fed746c28274bd67416616df6ed87b7c6eae25593792d1ce815760458d3"
    sha256                               catalina:       "d721fea1c78f6b79eb7ae7e325442e276638919bdef0a21604e910501d4cc67f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2174b375583cd65dd0bb371684b48fe05a346f16fad3c33d9bda51519a79d49f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cc3ad88464fb616899345d986acd64a8108ad271e4cc9d09370cd8055a1774f"
  end

  head do
    url "https://github.com/andreabolognani/cattle.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  def install
    pkgshare.mkpath
    cp_r ["examples", "tests"], pkgshare
    rm Dir["#{pkgshare}/{examples,tests}/{Makefile.am,.gitignore}"]

    if build.head?
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      system "sh", "autogen.sh"
    end

    mkdir "build" do
      system "../configure", "--disable-silent-rules", *std_configure_args
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
