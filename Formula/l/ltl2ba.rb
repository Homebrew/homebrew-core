class Ltl2ba < Formula
  desc "Translate LTL formulae to Buchi automata"
  homepage "https://lsv.ens-paris-saclay.fr/~gastin/ltl2ba/"
  url "https://lsv.ens-paris-saclay.fr/~gastin/ltl2ba/ltl2ba-1.3.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/ltl2ba-1.3.tar.gz"
  sha256 "912877cb2929cddeadfd545a467135a2c61c507bbd5ae0edb695f8b5af7ce9af"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://lsv.ens-paris-saclay.fr/~gastin/ltl2ba/download.php", post_form: {
      getltl2ba: "Get LTL2BA",
    }
    regex(/href=.*?ltl2ba[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "44343a3a706997bce508f8376785fa1f113926565bc18a57b0409545e1dff44d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "18b178bd47a42ca3c5ab755e80cb5ec5a087807c1bef4fc064aa97a3ff18d76a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5527191de9afab610f9d220b2c62ceed062df2e5e2c99b1743381c57067b9535"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89c79976b12030dc618c9466ad4f1f9f14fe9dff815850ac6ecc38ab10f63981"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e35ea05ee9b358df863d969c190abea48b61ec737c7aaa5fb01f9f7de455330"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "577639caaf79515113fee790d593bc735b9f54bbb2bf93ae2788655a455aecaa"
    sha256 cellar: :any_skip_relocation, sonoma:         "075820e7ecfee9fb538889ee1f2a32e0f3e4b0aa8ba8194c22418eb7d856abe3"
    sha256 cellar: :any_skip_relocation, ventura:        "18f8eb78ca95bd4217b9ca697e608c62cc0f0fb8a632585f3ce57f75e82b2b66"
    sha256 cellar: :any_skip_relocation, monterey:       "287ea81802bff62078478fccce3b85695feb945996f59bbf17d3e28712bb51ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "c85c152985dcdd33f028941a0b2e62d20d5f247142111b9fb30c11ea9dd424b7"
    sha256 cellar: :any_skip_relocation, catalina:       "ede3b5e5b22b886bce4f6f2ead352dc4a676e3d8a95f9543930f2be2b3a0b4b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7dcc015888d23a53ef7cb653015c0a93abad381753c277e6f76f535a13351e82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "948ef5632a4054316599f6361411d994459971c64749fe99609f13c3c51b9fe7"
  end

  def install
    system "make"
    bin.install "ltl2ba"
  end

  test do
    assert_match ":: (p) -> goto accept_all", shell_output("#{bin}/ltl2ba -f 'p if p ∈ w(0)'")
  end
end
