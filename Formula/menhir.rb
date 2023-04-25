class Menhir < Formula
  desc "LR(1) parser generator for the OCaml programming language"
  homepage "http://cristal.inria.fr/~fpottier/menhir"
  url "https://gitlab.inria.fr/fpottier/menhir/-/archive/20230415/menhir-20230415.tar.bz2"
  sha256 "d59f7998dcf9760e65a01ed31630578e0063f62458a6761fdd97bb30cbeb18d5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "39c9d69d90bc251653d9349ec110b38fec75b1943417e02cc9888cb810a46d69"
    sha256 cellar: :any,                 arm64_monterey: "1ea003c9e5bd73691f41ab71ba934ddbea62f57fe1b1b15dfbab8fcbf3630f36"
    sha256 cellar: :any,                 arm64_big_sur:  "a165da954d167ed379d524933eb9a7f3a89939b8361daab2c7b0439c39041a29"
    sha256 cellar: :any,                 ventura:        "69a4f3a97f287e1236ab3b8548d47c67d3334ac7889cd28a8645aa5eafc661e6"
    sha256 cellar: :any,                 monterey:       "764594181394cb0eac000a2e175ec1ce7fc8f255ace33f0b03792231120bc968"
    sha256 cellar: :any,                 big_sur:        "916e5297d186fb8beea51d6ee0a238e4f7231c2bd707c18daaa5ac96a8805c84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f032cf4f770db0750ef1a7f220b788810dcc21dbfd2accfb5ddd61f48fff85a"
  end

  depends_on "dune" => :build
  depends_on "ocamlbuild" => :build
  depends_on "ocaml"

  def install
    system "dune", "build", "@install"
    system "dune", "install", "--prefix=#{prefix}", "--mandir=#{man}"
  end

  test do
    (testpath/"test.mly").write <<~EOS
      %token PLUS TIMES EOF
      %left PLUS
      %left TIMES
      %token<int> INT
      %start<int> prog
      %%

      prog: x=exp EOF { x }

      exp: x = INT { x }
      |    lhs = exp; op = op; rhs = exp  { op lhs rhs }

      %inline op: PLUS { fun x y -> x + y }
                | TIMES { fun x y -> x * y }
    EOS

    system "#{bin}/menhir", "--dump", "--explain", "--infer", "test.mly"
    assert_predicate testpath/"test.ml", :exist?
    assert_predicate testpath/"test.mli", :exist?
  end
end
