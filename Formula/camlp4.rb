class Camlp4 < Formula
  desc "Tool to write extensible parsers in OCaml"
  homepage "https://github.com/ocaml/camlp4"
  url "https://github.com/ocaml/camlp4/archive/4.04+1.tar.gz"
  version "4.04+1"
  sha256 "6044f24a44053684d1260f19387e59359f59b0605cdbf7295e1de42783e48ff1"
  revision 1
  head "https://github.com/ocaml/camlp4.git", :branch => "trunk"

  bottle do
    cellar :any_skip_relocation
    sha256 "a26669d58078acd85fadd6314bfdddde22f2b34875cbc889ebf88a0413d7e727" => :sierra
    sha256 "e45aaad4dfc13a2b90282de5d57c218586f226e3d7d72d2f250279791580c70b" => :el_capitan
    sha256 "9029a3f7dcc18d08097427e9e320613a583f60f9e3f1ccbd4f09328b7dddd434" => :yosemite
  end

  depends_on "ocaml"
  # since OCaml 4.03.0, ocamlbuild is no longer part of ocaml
  depends_on "ocamlbuild"

  def install
    # this build fails if jobs are parallelized
    ENV.deparallelize
    system "./configure", "--bindir=#{bin}",
                          "--libdir=#{HOMEBREW_PREFIX}/lib/ocaml",
                          "--pkgdir=#{HOMEBREW_PREFIX}/lib/ocaml/camlp4"
    system "make", "all"
    system "make", "install", "LIBDIR=#{lib}/ocaml",
                              "PKGDIR=#{lib}/lib/ocaml/camlp4"
  end

  test do
    (testpath/"foo.ml").write "type t = Homebrew | Rocks"
    system "#{bin}/camlp4", "-parser", "OCaml", "-printer", "OCamlr",
                            "foo.ml", "-o", testpath/"foo.ml.out"
    assert_equal "type t = [ Homebrew | Rocks ];",
                 (testpath/"foo.ml.out").read.strip
  end
end
