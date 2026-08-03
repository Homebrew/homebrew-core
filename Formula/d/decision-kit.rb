class DecisionKit < Formula
  desc "Open-source CLI for random picks, dice, coin flips, and team splits"
  homepage "https://entscheidomat.com/"
  url "https://github.com/knuthtimo-lab/decision-kit/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "892634237e1613f0930eed641ba2f6051f851f474c9fa802e5c2aad820dfac66"
  license "MIT"

  depends_on "node"

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/cli.mjs"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/decision-kit --help")
  end
end
