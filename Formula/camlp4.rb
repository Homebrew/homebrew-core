class Camlp4 < Formula
  desc "Tool to write extensible parsers in OCaml"
  homepage "https://github.com/ocaml/camlp4"
  url "https://github.com/ocaml/camlp4/archive/4.08+1.tar.gz"
  version "4.08+1"
  sha256 "655cd3bdcafbf8435877f60f4b47dd2eb69feef5afd8881291ef01ba12bd9d88"
  head "https://github.com/ocaml/camlp4.git", :branch => "trunk"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f1cc081a2a79b1d41ac7f109800a730ad6ffb70b4ba1f83a72619786093a37a" => :catalina
    sha256 "0eeb91e592213855883d9387bbcb2a034250df388f5f3499210cc5aed60267c8" => :mojave
    sha256 "9fa35bb3cefc703afab585f87687df22a3542a7c076966693c5c8a663a3220d3" => :high_sierra
    sha256 "e39318a0bc39b66821eb35ac0a706f61754d2c27355bfe7da5a68a7bff05243c" => :sierra
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
