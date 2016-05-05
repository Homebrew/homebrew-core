class Camlp4 < Formula
  desc "Tool to write extensible parsers in OCaml"
  homepage "https://github.com/ocaml/camlp4"
  url "https://github.com/ocaml/camlp4/archive/4.03+1.tar.gz"
  version "4.03+1"
  sha256 "6eefeacced81cca59ddf90c2538505fd5cd6596a3fc1acf4971e9796c2e7f2ae"
  head "https://github.com/ocaml/camlp4.git", :branch => "trunk"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbfa590ccdfdfee06dbd5a751201bb8e74b469ef2e2b86755225ffb2eb4720da" => :el_capitan
    sha256 "6194932d62c0002c8286e7c7bf3d04272301669d2a036b7f9d717af3b1370ea4" => :yosemite
    sha256 "a791cec5c4ff4cec0bdff1f25ac2b1a6e906b3e9c485bac285d1b527c9caeeaa" => :mavericks
  end

  depends_on "ocaml"
  # since OCaml 4.03.0, ocamlbuild is no longer part of OCaml
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
