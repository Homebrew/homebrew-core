class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.47.tar.gz"
  sha256 "9e60d19e178c7e9d945bec0bae735a461315c5602e225d55b02fc23289a3f627"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "84c2dd621800ad4c4a1d8d3a27d19ed61b168a9fc12d875c513d43e7fd168858"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e0c7cb0364407699c9969c0df20fc603c3055fd50e220a476082917c665554f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "33bb1841ac86e4fa6f15c027395c66d66df94969e772c39df7814c1c9e53deb6"
    sha256 cellar: :any,                 arm64_linux:       "969ba58a5a0224c1ef4fc5293944a6922172bfdc59ca3d20edff5b5474705c37"
    sha256 cellar: :any,                 x86_64_linux:      "659d4d729832943b7c6cf398d8e626de3dd647479dd8d797e47c1cbbe4abdd0d"
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
