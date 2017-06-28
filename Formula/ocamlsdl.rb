class Ocamlsdl < Formula
  desc "OCaml interface with the SDL C library"
  homepage "https://ocamlsdl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ocamlsdl/OCamlSDL/ocamlsdl-0.9.1/ocamlsdl-0.9.1.tar.gz"
  sha256 "abfb295b263dc11e97fffdd88ea1a28b46df8cc2b196777093e4fe7f509e4f8f"
  revision 6

  bottle do
    cellar :any
    sha256 "3cbd8b17e7ba41062954cd36d3f784fffd3146b7aeb0f8872a908dfeaf65b62f" => :sierra
    sha256 "fff3e2f01f837db3fe9150f74938ac2c817f4601e0406f48081bcacecd782a5a" => :el_capitan
    sha256 "f2018ad8438395157b104d7f5579e956773f905aca1511331b9f7ad9f94d24bb" => :yosemite
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
