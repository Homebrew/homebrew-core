class Camlp4 < Formula
  desc "Tool to write extensible parsers in OCaml"
  homepage "https://github.com/ocaml/camlp4"
  revision 1
  head "https://github.com/ocaml/camlp4.git", :branch => "trunk"

  stable do
    url "https://github.com/ocaml/camlp4/archive/4.06+1.tar.gz"
    version "4.06+1"
    sha256 "b1cc51449da0537f6886e380815b716e7adc9d9a12d6098a06db2b2525bab922"

    # Remove for > 4.06+1
    patch do
      url "https://github.com/ocaml/camlp4/commit/aa57573.patch?full_index=1"
      sha256 "201d3b8ae1dc983679ad0ef93d6742bcd4453a3719288f6a738cf6c492fd694d"
    end
  end

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
