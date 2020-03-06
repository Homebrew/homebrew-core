class Ocamlsdl < Formula
  desc "OCaml interface with the SDL C library"
  homepage "https://ocamlsdl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ocamlsdl/OCamlSDL/ocamlsdl-0.9.1/ocamlsdl-0.9.1.tar.gz"
  sha256 "abfb295b263dc11e97fffdd88ea1a28b46df8cc2b196777093e4fe7f509e4f8f"
  revision 13

  bottle do
    cellar :any
    sha256 "9b8746dfb697548d75febd38d30d2da37d5607d952de6beb04ca953ae3aa1937" => :catalina
    sha256 "d31de998e5cf5d9ced506dd831f21a5e26037fcb267cd8e28119704d4c73e778" => :mojave
    sha256 "c108a69107578704b2e161ac6002e8d7b51f9f6442d2de52046c1df33e20f50a" => :high_sierra
    sha256 "dd2959698fbdde6d1cd947dd1c3c7b872cebbff43bac5b8ef6c4770bb4e4584e" => :sierra
  end

  depends_on "ocaml"
  depends_on "sdl"
  depends_on "sdl_gfx"
  depends_on "sdl_image"
  depends_on "sdl_mixer"
  depends_on "sdl_ttf"

  def install
    ENV["OCAMLPARAM"] = "safe-string=0,_" # OCaml 4.06.0 compat
    system "./configure", "--prefix=#{prefix}",
                          "OCAMLLIB=#{lib}/ocaml"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.ml").write <<~EOS
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
