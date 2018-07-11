class Camlp4 < Formula
  desc "Tool to write extensible parsers in OCaml"
  homepage "https://github.com/ocaml/camlp4"
  url "https://github.com/ocaml/camlp4/archive/4.07+1.tar.gz"
  version "4.07+1"
  sha256 "ecdb8963063f41b387412317685f79823a26b3f53744f0472058991876877090"
  head "https://github.com/ocaml/camlp4.git", :branch => "trunk"

  bottle do
    cellar :any_skip_relocation
    sha256 "a95531e6b2ff739b1179de25df8f34b57723656c6173c2359882e145818a057d" => :high_sierra
    sha256 "58e7d1d8c0ef7b975450a4ba355746ebde7e45f34e1f9d29e97af48ce710d8a1" => :sierra
    sha256 "948a7ead41070215d60515d1641e60124490d44eab23e3cccb311fe1c9942a60" => :el_capitan
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
