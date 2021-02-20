class Ltl2ba < Formula
  desc "Translate LTL formulae to Buchi automata"
  homepage "https://www.lsv.ens-cachan.fr/~gastin/ltl2ba/"
  url "https://www.lsv.fr/~gastin/ltl2ba/ltl2ba-1.3.tar.gz"
  sha256 "912877cb2929cddeadfd545a467135a2c61c507bbd5ae0edb695f8b5af7ce9af"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "577639caaf79515113fee790d593bc735b9f54bbb2bf93ae2788655a455aecaa"
    sha256 cellar: :any_skip_relocation, big_sur:       "c85c152985dcdd33f028941a0b2e62d20d5f247142111b9fb30c11ea9dd424b7"
    sha256 cellar: :any_skip_relocation, catalina:      "ede3b5e5b22b886bce4f6f2ead352dc4a676e3d8a95f9543930f2be2b3a0b4b4"
    sha256 cellar: :any_skip_relocation, mojave:        "3e5ddce23730195799dfe85c97a57d63e892f168cda5207c72c68b459e5a92a0"
    sha256 cellar: :any_skip_relocation, high_sierra:   "533a278e70570b8f83550c784ccb7c921d9fb5b93ac613c3f971703090dd7921"
  end

  def install
    system "make"
    bin.install "ltl2ba"
  end

  test do
    assert_match ":: (p) -> goto accept_all", shell_output("#{bin}/ltl2ba -f 'p if p ∈ w(0)'")
  end
end
