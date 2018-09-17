class Lablgtk < Formula
  desc "Objective Caml interface to gtk+"
  homepage "http://lablgtk.forge.ocamlcore.org"
  url "https://forge.ocamlcore.org/frs/download.php/1726/lablgtk-2.18.6.tar.gz"
  sha256 "4ddca243066418e2a88ac49ebf2d846fac4b667b1b1753efadd078ae777368f8"
  revision 2

  bottle do
    sha256 "98276fb90ba8e45792ab5e4be38d54429fb4d9676e6ad6db934e2903c7effb51" => :mojave
    sha256 "eb823d2a1b43d7c99f1b38dbc0205b4b7729f1b76741efbc0b15b0210ff3da64" => :high_sierra
    sha256 "1517e5316269f22d9c31f9838933bf7f143ef2ce0d6cad244a25af91b7b55d52" => :sierra
    sha256 "7c19ea1b679cc0da78498ab2b9f2ca080cd7f12294a7fb915947940196c6c974" => :el_capitan
  end

  depends_on "camlp4" => :build
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
    system "ocamlc", "-I", "#{opt_lib}/ocaml/lablgtk2", "lablgtk.cma", "gtkInit.cmo", "test.ml", "-o", "test",
      "-cclib", "-latk-1.0",
      "-cclib", "-lcairo",
      "-cclib", "-lgdk-quartz-2.0",
      "-cclib", "-lgdk_pixbuf-2.0",
      "-cclib", "-lgio-2.0",
      "-cclib", "-lglib-2.0",
      "-cclib", "-lgobject-2.0",
      "-cclib", "-lgtk-quartz-2.0",
      "-cclib", "-lgtksourceview-2.0",
      "-cclib", "-lintl",
      "-cclib", "-lpango-1.0",
      "-cclib", "-lpangocairo-1.0"
    system "./test"
  end
end
