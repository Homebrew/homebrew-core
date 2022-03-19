class Lablgtk < Formula
  desc "Objective Caml interface to gtk+"
  homepage "http://lablgtk.forge.ocamlcore.org"
  url "https://github.com/garrigue/lablgtk/archive/2.18.12.tar.gz"
  sha256 "43b2640b6b6d6ba352fa0c4265695d6e0b5acb8eb1da17290493e99ae6879b18"
  license "LGPL-2.1"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "f46ccbac4b613f1542bdbe5bf0747c4875c2e89b2978589468d97aa6168a3ffc"
    sha256 cellar: :any, arm64_big_sur:  "33da190e1a69924c98e6a745380228562182abe3e13406301da4dd76dd42b694"
    sha256 cellar: :any, monterey:       "2d7d514c6d7c31faa53b5e0292a7d4962f1c60e4bc524f4344b7895b15756e5d"
    sha256 cellar: :any, big_sur:        "acd2ebe952607c8ad6d2fdb430fc5ad7f2f06742c3b3c571e943afc315293116"
    sha256 cellar: :any, catalina:       "6d376c548d8cc2580b3756daedbcd24b8f33900509977a6192b34f009dc6964b"
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
