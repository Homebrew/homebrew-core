class Oscats < Formula
  desc "Computerized adaptive testing system"
  homepage "https://code.google.com/archive/p/oscats/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/oscats/oscats-0.6.tar.gz"
  sha256 "2f7c88cdab6a2106085f7a3e5b1073c74f7d633728c76bd73efba5dc5657a604"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3ec330e90206d25a5d892d835f6bd6ab42bc1c21f557a578e4875add50315eff"
    sha256 cellar: :any,                 arm64_monterey: "8f09201bc284042b8bc6b011e32b51a1d538a6296ffc131b42a185b97abc434f"
    sha256 cellar: :any,                 arm64_big_sur:  "b5c6f901dc2b45d722e956303ed3641fe01244e68f62fa8cf10470cc3265b958"
    sha256 cellar: :any,                 ventura:        "8b192935c2d2e8464a7fcd794ef01bb3c54b254791edbe4b2490a5e2a48ee4b3"
    sha256 cellar: :any,                 monterey:       "c9d55286b8b305eae9dfb3197106f554b0d1bdcf92633d6c6427f5344a850f1c"
    sha256 cellar: :any,                 big_sur:        "73cb9b21da4992eff3d190c845f4155b0944c5fad019fdd283cee03c85227de6"
    sha256 cellar: :any,                 catalina:       "95b0bdf846ead03d50cd163c7f457049684a4b6c07cb30a7c2cd4953adb43389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51df849c182c9456521c13b109ac58acc24df705578bfacc3be312ba49e1405e"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"
  depends_on "gsl"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  # Fix issue with conflicting definitions of select on Linux.
  # Patch submitted to discussion group:
  # https://groups.google.com/g/oscats/c/WZ7gRjkxmIk.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/29a7d4c819af3ea8e48efb68bb98e6bd2a4b6196/oscats/linux.patch"
    sha256 "95fcfa861ed75a9292a6dfbb246a62be3ad3bd9c63db43c3d283ba68069313af"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "examples"
    # Fix shim references in examples Makefile.
    if OS.mac?
      inreplace pkgshare/"examples/Makefile",
        Superenv.shims_path/"pkg-config",
        Formula["pkg-config"].opt_bin/"pkg-config"
    else
      inreplace pkgshare/"examples/Makefile", Superenv.shims_path/"ld", "ld"
    end
  end

  test do
    pkg_config_flags = shell_output("pkg-config --cflags --libs oscats glib-2.0").chomp.split
    system ENV.cc, pkgshare/"examples/ex01.c", *pkg_config_flags, "-o", "ex01"
    assert_match "Done", shell_output("#{testpath}/ex01")
  end
end
