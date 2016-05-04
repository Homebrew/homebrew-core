class Ocamlsdl < Formula
  desc "OCaml interface with the SDL C library"
  homepage "http://ocamlsdl.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ocamlsdl/OCamlSDL/ocamlsdl-0.9.1/ocamlsdl-0.9.1.tar.gz"
  sha256 "abfb295b263dc11e97fffdd88ea1a28b46df8cc2b196777093e4fe7f509e4f8f"
  revision 3

  bottle do
    cellar :any
    sha256 "af199de8f5cdf64a79c9f43f532d67eee2fa60abbefacb6b04e4e531bf64ba91" => :el_capitan
    sha256 "7876e3bbd9febeff6658fb512769c673ba30efecee61558268be0db55cfa770c" => :yosemite
    sha256 "dd8d3374ff57ad41031b40bba4e9e3c142c6ca48c8915f48ec07831f9400cff1" => :mavericks
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
