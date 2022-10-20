class Lablgtk < Formula
  desc "Objective Caml interface to gtk+"
  homepage "http://lablgtk.forge.ocamlcore.org"
  url "https://github.com/garrigue/lablgtk/archive/2.18.12.tar.gz"
  sha256 "43b2640b6b6d6ba352fa0c4265695d6e0b5acb8eb1da17290493e99ae6879b18"
  license "LGPL-2.1"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "97abc8b9ca15184d58e73218a5617d417efc94183ae8ff6bb2bb5e6e4dd2efd2"
    sha256 cellar: :any, arm64_big_sur:  "4cacdcf4beb3a2d2621a2728b816c32b732a76fa48ae5a2db81aa5c2ceb083b3"
    sha256 cellar: :any, monterey:       "3481e18fe254c2bd1933ff9ef091b4d3345635825482540a014645e8b16219ed"
    sha256 cellar: :any, big_sur:        "4535ca14378ec4580014e81f636cbccd335e03d40de2710cbbc2102cca02c3a3"
    sha256 cellar: :any, catalina:       "6693d979ec1eba98402d6b5f6747de3ce204567b53e37144231b26731173a620"
    sha256               x86_64_linux:   "30f9191323a86ef69a1794027fdf8c6ef6b49b97df043732038bb0c9423c1b2e"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "gtksourceview"
  depends_on "librsvg"
  depends_on "ocaml"

  def install
    system "./configure", "--bindir=#{bin}",
                          "--libdir=#{lib}",
                          "--mandir=#{man}",
                          "--with-libdir=#{lib}/ocaml"
    ENV.deparallelize
    system "make", "world"
    system "make", "old-install"
  end

  test do
    (testpath/"test.ml").write <<~EOS
      let _ =
        GtkMain.Main.init ()
    EOS
    ENV["CAML_LD_LIBRARY_PATH"] = "#{lib}/ocaml/stublibs"
    cclibs = [
      "-cclib", "-latk-1.0",
      "-cclib", "-lcairo",
      "-cclib", "-lgdk-quartz-2.0",
      "-cclib", "-lgdk_pixbuf-2.0",
      "-cclib", "-lgio-2.0",
      "-cclib", "-lglib-2.0",
      "-cclib", "-lgobject-2.0",
      "-cclib", "-lgtk-quartz-2.0",
      "-cclib", "-lgtksourceview-2.0",
      "-cclib", "-lpango-1.0",
      "-cclib", "-lpangocairo-1.0"
    ]
    cclibs += ["-cclib", "-lintl"] if OS.mac?
    system "ocamlc", "-I", "#{opt_lib}/ocaml/lablgtk2", "lablgtk.cma", "gtkInit.cmo", "test.ml",
           "-o", "test", *cclibs
    # Disable this part of the test because display is not available on Linux.
    system "./test" if OS.mac?
  end
end
