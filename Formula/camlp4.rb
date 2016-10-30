class Camlp4 < Formula
  desc "Tool to write extensible parsers in OCaml"
  homepage "https://github.com/ocaml/camlp4"
  url "https://github.com/ocaml/camlp4/archive/4.03+1.tar.gz"
  version "4.03+1"
  sha256 "6eefeacced81cca59ddf90c2538505fd5cd6596a3fc1acf4971e9796c2e7f2ae"
  head "https://github.com/ocaml/camlp4.git", :branch => "trunk"

  bottle do
    cellar :any_skip_relocation
    sha256 "a25b9822e4cac3ab1e1434f801a21dce4a59b1be5fcf8633031195859a92a76e" => :sierra
    sha256 "8393f45f735de47ccae58ea6974aacd34770449980664377b7533a6de8a08c25" => :el_capitan
    sha256 "5fb90eba1c7b96d259b6dff9049b52d2aee380ff3312376514f96fbd6bd2b613" => :yosemite
    sha256 "e7082ef589dbf2df951d3da8caaafacfada7def89ae24bde05fb1eb29b12d09d" => :mavericks
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
