class Ltl2ba < Formula
  desc "Translate LTL formulae to Buchi automata"
  homepage "https://www.lsv.ens-cachan.fr/~gastin/ltl2ba/"
  url "https://www.lsv.fr/~gastin/ltl2ba/ltl2ba-1.2.tar.gz"
  sha256 "9dfe16c2362e953982407eabf773fff49d69b137b13bd5360b241fb4cf2bfb6f"

  bottle do
    cellar :any_skip_relocation
    sha256 "453d994d206ec034580146ff6da2661db60c90fd105867fef4be5eb6f7ff062a" => :catalina
    sha256 "c5a444d20a1811bf071cdc9c95ffbc272f68283978cbdd676b588ffd9c58735b" => :mojave
    sha256 "e2d8c66cb983cdcca984048d83a3938158f5286d283cf69df40cc2d8b0c70ff4" => :high_sierra
  end

  def install
    system "make"
    bin.install "ltl2ba"
  end

  test do
    assert_match ":: (p) -> goto accept_all", shell_output("#{bin}/ltl2ba -f 'p if p ∈ w(0)'")
  end
end
