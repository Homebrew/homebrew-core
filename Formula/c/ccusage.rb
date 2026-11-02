class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.48.tar.gz"
  sha256 "873850969ef9e225289772bcaa3a8bab0bafec9b57ec80db3d819b2b139d164f"
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
    url "https://raw.githubusercontent.com/BerriAI/litellm/6be98d8c751f874aa038dbb556e8b12d647c9b16/model_prices_and_context_window.json"
    version "6be98d8c751f874aa038dbb556e8b12d647c9b16"
    sha256 "66f19ab7802683f94efc96c01005f47917a05fc0cca62316961ba71cb5203dc0"

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
