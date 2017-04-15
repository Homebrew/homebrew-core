class Ocamlsdl < Formula
  desc "OCaml interface with the SDL C library"
  homepage "https://ocamlsdl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ocamlsdl/OCamlSDL/ocamlsdl-0.9.1/ocamlsdl-0.9.1.tar.gz"
  sha256 "abfb295b263dc11e97fffdd88ea1a28b46df8cc2b196777093e4fe7f509e4f8f"
  revision 5

  bottle do
    cellar :any
    sha256 "cad75622c767f4e08cb367cffec7e4ad4e3ebdad501807c27c893a28e0adf81e" => :sierra
    sha256 "63e481cde43f1c8cd108627513a59c31d1d97a42077573d6de9b53ec1909117c" => :el_capitan
    sha256 "99d9e398a1f74a9b653fe304605258cc8b6e41d553ce83e9a0e2e26e0a16edde" => :yosemite
  end

  depends_on "sdl"
  depends_on "ocaml"
  depends_on "sdl_mixer" => :recommended
  depends_on "sdl_image" => :recommended
  depends_on "sdl_gfx" => :recommended
  depends_on "sdl_ttf" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}",
                          "OCAMLLIB=#{lib}/ocaml"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.ml").write <<-EOS.undent
      let main () =
        Sdl.init [`VIDEO];
        Sdl.quit ()

      let _ = main ()
    EOS
    system "#{Formula["ocaml"].opt_bin}/ocamlopt", "-I", "+sdl", "sdl.cmxa",
           "-cclib", "-lSDLmain", "-cclib", "-lSDL", "-cclib",
           "-Wl,-framework,Cocoa", "-o", "test", "test.ml"
    system "./test"
  end
end
