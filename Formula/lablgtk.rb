class Lablgtk < Formula
  desc "Objective Caml interface to gtk+"
  homepage "http://lablgtk.forge.ocamlcore.org"
  url "https://forge.ocamlcore.org/frs/download.php/1627/lablgtk-2.18.5.tar.gz"
  sha256 "2bf251db21c077fdd26c035ea03edd8fe609187f908e520e87a8ffdd9c36d233"
  revision 3

  bottle do
    sha256 "a956e73f8deea488799703ceafeaa4e7e736b64847c2cc0160c08e518025d2e8" => :sierra
    sha256 "15c7a7188e155ac98921446a61782ad35910fa75790cfcec6529051859ddab21" => :el_capitan
    sha256 "830cbc340370559d559520d9c68b29704213a86f293a1294ab2d11b183430e27" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "camlp4" => :build
  depends_on "ocaml"
  depends_on "gtk+"
  depends_on "librsvg"
  depends_on "gtksourceview"

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
    (testpath/"test.ml").write <<-EOS.undent
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
