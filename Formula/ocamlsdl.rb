class Ocamlsdl < Formula
  desc "OCaml interface with the SDL C library"
  homepage "https://ocamlsdl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ocamlsdl/OCamlSDL/ocamlsdl-0.9.1/ocamlsdl-0.9.1.tar.gz"
  sha256 "abfb295b263dc11e97fffdd88ea1a28b46df8cc2b196777093e4fe7f509e4f8f"
  revision 5

  bottle do
    cellar :any
    sha256 "e3cac43ef919a0358c90ea23b472e253429e68e5f02df59ffef9b85d1d189de8" => :sierra
    sha256 "33b4dcb486909410434a14cc34a31a002bbe8629276836778d8f767fa1471703" => :el_capitan
    sha256 "49ea552493b5d37783182e0fe444914bef8f6e4d5bb5978f831b6c6bd375ad4a" => :yosemite
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
