class Ocamlsdl < Formula
  desc "OCaml interface with the SDL C library"
  homepage "http://ocamlsdl.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ocamlsdl/OCamlSDL/ocamlsdl-0.9.1/ocamlsdl-0.9.1.tar.gz"
  sha256 "abfb295b263dc11e97fffdd88ea1a28b46df8cc2b196777093e4fe7f509e4f8f"
  revision 3

  bottle do
    cellar :any
    sha256 "9e204be255cb230219be35d48574b4ca8765ab612f072015a3a049e25afb473e" => :sierra
    sha256 "63049f59ee0cb7ecb2ec879a6ba42d0257982a5e1496f766eb7a6af434316739" => :el_capitan
    sha256 "e3c19d6e291f992746d2e97c3359926f31d1352c4c624e390832500376123f28" => :yosemite
    sha256 "84e41d71d0d1325233ff60d1714bc4f2790c62ec2f770fb369b2c02447c347c7" => :mavericks
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
