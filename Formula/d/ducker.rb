class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https://github.com/robertpsoane/ducker"
  url "https://github.com/robertpsoane/ducker/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "6b00e1779483bd2fe057c1842db5d446e44a1dda6c551f30e86eeee944b49a22"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb623bba60f88c43cd88507d3fb236005251c26f1f4538382b72c07522846fdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "222254278f39b173121c961c3fc2fd210463287c1d0f1d5842c6b16cf38176f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "919dbc90abd66f08a06d50112a547eec157902f39ede120f6b130989166bf0d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb67ba4031ad1736b8e701b77fd621f885b65effba1fb8a94e6dc2d007a409de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c0c0bdc7a7b7de866ca3a0476127c69d1c2aaae977097bc0f1bd14d16ed8f6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19cc5444742e9e43854b51f0ff688f34699911c9a6bc14f56dc516e61e95d483"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ducker", "--export-default-config"
    assert_match "prompt", (testpath/".config/ducker/config.yaml").read

    assert_match "ducker #{version}", shell_output("#{bin}/ducker --version")
  end
end
