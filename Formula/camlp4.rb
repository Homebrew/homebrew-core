class Camlp4 < Formula
  desc "Tool to write extensible parsers in OCaml"
  homepage "https://github.com/ocaml/camlp4"
  url "https://github.com/ocaml/camlp4/archive/4.07+1.tar.gz"
  version "4.07+1"
  sha256 "ecdb8963063f41b387412317685f79823a26b3f53744f0472058991876877090"
  head "https://github.com/ocaml/camlp4.git", :branch => "trunk"

  bottle do
    cellar :any_skip_relocation
    sha256 "83245cd4c3c676b924ca2e50a22e3ce2691fe8222b57ceb20a668e61cedf2134" => :mojave
    sha256 "a54248473ee2730cd7a78f204bf98067ddda11aeafaebbe5c2842021ae766f43" => :high_sierra
    sha256 "fa95192b50365b2b75ea025aa99b9f9bbaf5c1362c612d1eac1b4eebee012dc5" => :sierra
    sha256 "bf8b4e53abfca6f7721315d0f898406cd3dcbafc02675f582dd6fb9d08c1cf82" => :el_capitan
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
