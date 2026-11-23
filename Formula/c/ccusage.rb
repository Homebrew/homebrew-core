class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.1.1.tar.gz"
  sha256 "66440b75d35ebab32b33ad7777dfee3362b49f64d2acfcfc93628e77f203dcd8"
  license "MIT"

  bottle do
    manifest_sha256 "29b7a3d864f59210cf58db612a90b9c1d103ec28a32323d8d2844d7b6963b86a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "078d661abab87bad1bcd03fe0174f6dbe83c5996b4a9cbcd69b8f5434c227efe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a920ea6af21d51e6801f6ce4c56f55fa1b7ce4006f0ed8c2bbc5127f1bef7f3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fdbe61b529f45e2d2ca03b880984a520d9c9bf032ffaef863cf4902daa81477c"
    sha256 cellar: :any,                 arm64_linux:       "0e1321d0cf2a020efda52ac22e8d97437ba21419ae5284aef78332e1c38f6ed7"
    sha256 cellar: :any,                 x86_64_linux:      "5959381ffb4d8c98547e18201739386158bb926f8d1d9b0df3ae65776c95e670"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://raw.githubusercontent.com/BerriAI/litellm/9bf9d88111b27f9978de80a3149e381849da83ba/model_prices_and_context_window.json"
    version "9bf9d88111b27f9978de80a3149e381849da83ba"
    sha256 "21523c8f267eac4c915855af42a70d00b2c878e13b8a85547fd8855b49c69dec"

    # Fetch the latest available resource
    livecheck do
      url "https://api.github.com/repos/BerriAI/litellm/branches/main"
      strategy :json do |json|
        json.dig("commit", "sha")
      end
    end
  end

  deny_network_access!

  def fetch
    cd "rust" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    resource("litellm-pricing-json").stage buildpath
    ENV["CCUSAGE_PRICING_JSON_PATH"] = buildpath/"model_prices_and_context_window.json"
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage")
  end

  test do
    ENV["CLAUDE_CONFIG_DIR"] = testpath
    project = testpath/"projects/homebrew"
    project.mkpath
    [["first", 100, 25], ["second", 200, 50]].each do |session, input_tokens, output_tokens|
      (project/"#{session}.jsonl").write JSON.generate(
        timestamp: "2026-05-22T02:34:40.000Z",
        message:   {
          id:    session,
          model: "claude-sonnet-4-20250514",
          usage: { input_tokens:, output_tokens: },
        },
      )
    end

    output = shell_output("#{bin}/ccusage claude daily --offline --json --no-cost --timezone UTC " \
                          "--since 2026-05-22 --until 2026-05-22")
    totals = JSON.parse(output).fetch("totals")
    assert_equal 300, totals.fetch("inputTokens")
    assert_equal 75, totals.fetch("outputTokens")
    assert_equal 375, totals.fetch("totalTokens")
  end
end
