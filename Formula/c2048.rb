class C2048 < Formula
  desc "Console version of 2048"
  homepage "https://github.com/mevdschee/2048.c"
  url "https://github.com/mevdschee/2048.c.git",
      revision: "578a5f314e1ce31b57e645a8c0a2c9d9d5539cde"
  version "0+20150805"
  license "MIT"
  head "https://github.com/mevdschee/2048.c.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa6a9009c2300a5ecb2dcde91e5c416363d5293e2e166a715eb4792c33e188a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89bc7f84063b8621271115ee8f9c84c836ae1e57a72db5533b11d8247d57e043"
    sha256 cellar: :any_skip_relocation, monterey:       "011a8529dc50ea6349f9b1d288ae11fac8e4a4969372c66036b31d158e960b5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "abe17673a8930d93f04d97f5e209621b83968e28a075578e9b1f42c07464145d"
    sha256 cellar: :any_skip_relocation, catalina:       "727165d714b210f559b5f5450d6608bed0e7bfbf87c7a7cd5994259b65865411"
    sha256 cellar: :any_skip_relocation, mojave:         "dd0cc60f407ccb43f471d7123b9a09fa0b2161ee083638a432ee25795a96ca8f"
    sha256 cellar: :any_skip_relocation, high_sierra:    "e5f553baf87fc7ac9f0fa4471d3e9be29328df167700181d9663f61293436888"
    sha256 cellar: :any_skip_relocation, sierra:         "d2f33783cf7cd2ac69eaed113d940aca31e02e5863fcdb40e200e3fe9a4d0623"
    sha256 cellar: :any_skip_relocation, el_capitan:     "8f9e75196f87718be0c572f731cecba0c8cd4e8dc35f8b3027392cd6e1c45f5d"
    sha256 cellar: :any_skip_relocation, yosemite:       "c06bde9e58788a1a4f16b6d0ace89be02cf07f86211e0c78af5fdaa7d70a3614"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a13bac58f461c8fff9257a3af3f01569d0bf819248ddbf5840bbf1fc9492adfa"
  end

  def install
    system "make"
    bin.install "2048"
  end

  def caveats
    <<~EOS
      The game supports different color schemes.
      For the black-to white:
        2048 blackwhite
      For the blue-to-red:
        2048 bluered
    EOS
  end

  test do
    system "#{bin}/2048", "test"
  end
end
