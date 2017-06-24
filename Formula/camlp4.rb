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
    sha256 "49096259b8b6ca8de2e13430ca64667e7240ea4c57ceec970ec09c6018e92afa" => :sierra
    sha256 "2653f7e820938274b150429ae79c8b7384a93e655707f1c028577ad46eb720f7" => :el_capitan
    sha256 "368d94cdd7367926ad0c77e0c818a3f4cbc09fc2cdbd9ad35dd391f90b2eef9a" => :yosemite
  end

  depends_on "ocaml"
  # since Ocaml 4.03.0, ocamlbuild is no longer part of ocaml
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
