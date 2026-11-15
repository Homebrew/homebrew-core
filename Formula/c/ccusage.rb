class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.51.tar.gz"
  sha256 "71ce87c83264c64a13232a4f049a18d4902422e629ac7146cf0111b74260b713"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a275be65581ed04679bdc27f3bd47f2ca5a0074769a15ea607866755281db318"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "486138504f904ad641ce70ed99eac935460278b8fae3a65d368886dab7c045fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "741f4be3e53fec443c3f5aa4ca01351f1ebb6bb55134a818980d14547d6d00de"
    sha256 cellar: :any,                 arm64_linux:       "fc39fc0f9465b87a03515b2612cba5224a23daf4f316a2cd8d29bb56f1df118c"
    sha256 cellar: :any,                 x86_64_linux:      "e4b466b86dcccf454bf184c9381d0b49c9e9c1f51e7f5162a3682a3ff5645b8a"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://raw.githubusercontent.com/BerriAI/litellm/27c796c412eed2f7336dccb46a58247463b7c498/model_prices_and_context_window.json"
    version "27c796c412eed2f7336dccb46a58247463b7c498"
    sha256 "c5658d536b6d5c020c679631c0a9b69b35b19bf5eb5edd64a2bb8079fe1bf97a"

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
