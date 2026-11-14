class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.51.tar.gz"
  sha256 "71ce87c83264c64a13232a4f049a18d4902422e629ac7146cf0111b74260b713"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "10a8588b915ae28a575cf32eaf86ceed90bf23f1f71e8c1e3f96e5142e6f8977"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "edfc83e1db60105b3474d10a715326f41976511c9476967e804a350c22b8a23f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9dff40b1f511d688ddf8f329c11bb8950f6a7691675cff93fdb9572b40173db9"
    sha256 cellar: :any,                 arm64_linux:       "f59a5265eac28e6a6db8faff636eb2304f4dbe6382930e03e69612c863c9ae69"
    sha256 cellar: :any,                 x86_64_linux:      "ca3c83070d6e9b55ef98e026e90b7ed9c74817c7c6e9621d04ae2817f6959a0a"
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
