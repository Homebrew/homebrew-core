class Matterbridge < Formula
  desc "Protocol bridge for multiple chat platforms"
  homepage "https://github.com/42wim/matterbridge"
  url "https://github.com/42wim/matterbridge/archive/v1.25.0.tar.gz"
  sha256 "c8ae52a07d06f416ba9439f0b8fa9163c6f19ca4520a941eb4f6aa5452682017"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27b75c390b00d36e940f4e1580c5efe4d9e6008ff42ef5e64fd453f0cee8f621"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3907784d052c8aa47136c5ad24bcac497c5404b2a46948321b08c2e2ce58baab"
    sha256 cellar: :any_skip_relocation, monterey:       "a41b0e00665b4912030afa884e05b2797fb7e74248e88348460e05bafa3a1d5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdf0d040b28d6f27f905bed42085d1d4bb64651f53206701ac9b5da7d2f74e41"
    sha256 cellar: :any_skip_relocation, catalina:       "e3762c6c2e3f16796f4dcf5ddbad1ff096dd45d26bc14157ad61a97c3b403079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dee810f815eebe7d90a1ca46f5f1559b87b20581df5341970566f985a6a3117"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    touch testpath/"test.toml"
    assert_match "no [[gateway]] configured", shell_output("#{bin}/matterbridge -conf test.toml 2>&1", 1)
  end
end
