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
    sha256 "027ead4bab995b5bd51b963e5d6812f4a1d4cc6a6b4f511c587ad80c339a6bef" => :high_sierra
    sha256 "cccbdbb136350dbf57b98a65aee2226bb7ecfd9b76258f83f981fc5bdabf2a9a" => :sierra
    sha256 "4d197f8765442ccfa03f94e4d9fb2b1a3449f030bbf34bffa0628539998f2b1d" => :el_capitan
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
