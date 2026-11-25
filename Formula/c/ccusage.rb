class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.1.2.tar.gz"
  sha256 "9d69db8b290e04526e2cdaa090a9569ce75b1ba020d6ef5e2e07c657ec1db4b1"
  license "MIT"

  bottle do
    manifest_sha256 "8e9c34ceff50aea55526c151160b2cfd9f8381235508edb98b48d6a634399bd3"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "166658e7e028744cf6fa7829b8df7cb2c90157b47cff9140628c9dfaa8b478c9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf1d84bb473b6493245b32f53d63d5a2456bdc74dd453b419c9e39d619344b49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bf87209b19b21eb2d016d4536b2a904b3e9feab11e1b5964a7501fd629602443"
    sha256 cellar: :any,                 arm64_linux:       "98479a1a8aa32bd453b8b64a2641a3e853216310e63f5e69e3817c66a5b4c82b"
    sha256 cellar: :any,                 x86_64_linux:      "f6bb0122fddcdf2ac0e9742e94c6f31d96dc38557dffdd009cbe31f62f1424f2"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://raw.githubusercontent.com/BerriAI/litellm/6e3ad131cfb40938f044e006527d02abcf86c9d1/model_prices_and_context_window.json"
    version "6e3ad131cfb40938f044e006527d02abcf86c9d1"
    sha256 "996c36cd33eb92beecd6eab19ef7291d0dcd6f0780fc375283bcd197d88ee62f"

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
