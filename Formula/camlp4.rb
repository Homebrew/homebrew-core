class Camlp4 < Formula
  desc "Tool to write extensible parsers in OCaml"
  homepage "https://github.com/ocaml/camlp4"
  url "https://github.com/ocaml/camlp4/archive/4.08+1.tar.gz"
  version "4.08+1"
  sha256 "655cd3bdcafbf8435877f60f4b47dd2eb69feef5afd8881291ef01ba12bd9d88"
  head "https://github.com/ocaml/camlp4.git", :branch => "trunk"

  bottle do
    cellar :any_skip_relocation
    sha256 "4052c0b687d48ea6aebcdd44159d2a3ef187e70776727b53071bea13d144aec5" => :mojave
    sha256 "2916c776974e59cd6b8813208f538736456dc6c59fdced7eb360fba1a3bb23af" => :high_sierra
    sha256 "2c23be2683a05c7214898f88f00abcbc711bd8d68a96f85e2f2220f8d5a9d6a3" => :sierra
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

    (testpath/"try_camlp4.ml").write "open Camlp4"
    system "ocamlc", "-c", "-I", "#{HOMEBREW_PREFIX}/lib/ocaml/camlp4", "-o", testpath/"try_camlp4.cmo", testpath/"try_camlp4.ml"
  end
end
