class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.47.tar.gz"
  sha256 "9e60d19e178c7e9d945bec0bae735a461315c5602e225d55b02fc23289a3f627"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8b42dcd8e978ad13bb24bc2f2185b648d61ee6dde6466ec407f5d7e2b1a22190"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f393010b4a60e47f2531b34db08149ad39d82b8c140fd2dd48c0e2acd0264a94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7dc9ab8e6da73816f24194fd38baf36846f0510451c34e8cbbc0cc8d886be3da"
    sha256 cellar: :any,                 arm64_linux:       "48a8f31b3bf2909efd26574b3f71349237bc1dfb612dedfec56e4566757c5e08"
    sha256 cellar: :any,                 x86_64_linux:      "a0680b0f392eb3ed5c63a5841ad2b9b6fbcb74b17b2d8d7ed7a7ce9b83dc9881"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://raw.githubusercontent.com/BerriAI/litellm/60fc121ce8ab995cb2997e0bbd0a980ee93c627d/model_prices_and_context_window.json"
    version "60fc121ce8ab995cb2997e0bbd0a980ee93c627d"
    sha256 "7f7f1567bee2b7ba4118e4b9b3c1de70b122fd9164f69d9adfc12aca1033101a"

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
    assert_match "No usage data found.", shell_output("#{bin}/ccusage 2>&1")
  end
end
