class Lablgtk < Formula
  desc "Objective Caml interface to gtk+"
  homepage "http://lablgtk.forge.ocamlcore.org"
  url "https://forge.ocamlcore.org/frs/download.php/1627/lablgtk-2.18.5.tar.gz"
  sha256 "2bf251db21c077fdd26c035ea03edd8fe609187f908e520e87a8ffdd9c36d233"
  revision 3

  bottle do
    sha256 "b68b31925014914d1ce21cd8dbf2aed4e6b0cd29d6dcdd2e9b1f5470e7c13660" => :high_sierra
    sha256 "77428605ba03b69017780746d0ea7f9f4c79a3ef9879bdcf94d2be4fb426fe93" => :sierra
    sha256 "f11a0ca14c62048709b44a00f49a174c0b00b35119fe39b5a4776fce6b186153" => :el_capitan
    sha256 "4aa4b81d7a0c102be6940560ca49511e4c2d140442a3b39ba1b46326b0801762" => :yosemite
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
