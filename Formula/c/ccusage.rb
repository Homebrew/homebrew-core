class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.49.tar.gz"
  sha256 "ac8a8f5b28e670820b43f9778b3a3c94d52a3e9a2f7dee22a407560f0e8cf04e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2d78a946a66293978fbb8c81f41df19dab39a80ccff28225a8ac816d74e0b9fd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c01a9aa46e4985e413d8370792a37fca6e2208628987fbce9c6fdedce9e42dc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a86d761f76254f1ed81afc32b1f30a7606bb88f925b8ae0bf6ee3398bc322052"
    sha256 cellar: :any,                 arm64_linux:       "6636c24e9c30375ae1cbdbea3aa3ad80e328353a67c85873cea8499a3a397188"
    sha256 cellar: :any,                 x86_64_linux:      "8a873620a76fe2516c952ab299d6e5da32263a0e18ea1a8c7d57a07ee484885f"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://raw.githubusercontent.com/BerriAI/litellm/263281ac89c9b81b17451f0c5c84126ccb2f6213/model_prices_and_context_window.json"
    version "263281ac89c9b81b17451f0c5c84126ccb2f6213"
    sha256 "2a9027b9816a876bb9f860741476eb5a240e8cd2f4252d6b528e4d604aef5c7b"

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
