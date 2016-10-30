class Lablgtk < Formula
  desc "Objective Caml interface to gtk+"
  homepage "http://lablgtk.forge.ocamlcore.org"
  url "https://forge.ocamlcore.org/frs/download.php/1602/lablgtk-2.18.4.tar.gz"
  sha256 "b316ae0b92e760c1ab0d1bdeaa0a3c2a6ab14face5a0fe2b93445be3a3d013c0"

  bottle do
    sha256 "e7adebf1482d9752231d869b44cb56cf47dbef89a6eb074f2ae4872d16afe05d" => :sierra
    sha256 "2d577a0bd0e44f54456ddd73d998c552812a20e0dc4fa17ec0c39cdfe7859206" => :el_capitan
    sha256 "8119325541fe1f222d5174126c54edecab8be1b91622f007d574714ad4e66a8f" => :yosemite
    sha256 "4c650d1ae2959ab8fa796c3075b96527025e2a133d6797188b96d37b55f62353" => :mavericks
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
    ENV.j1
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
