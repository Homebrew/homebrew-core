class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.26.tar.gz"
  sha256 "ac356a431bc8703ad2548d5913f2c0797b2ddfeb0058c2afd7235796159f5002"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5eec705be0708b2a354a0ae2505689d9d835b7567afa2bbcaf276d232f566d34"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f332caf30adb728ccde3440eab03d5e7e637773fea4384ce0dd72e230b2176d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a71d519f8ffa2ea29e8ff57cf1ba1b692757c001f0c4c167126331e3cdc22bb5"
    sha256 cellar: :any,                 arm64_linux:       "d1d96fca552c0c95e4d92931456923b24d57695c6dcd2b8857ea2b7bd657cd39"
    sha256 cellar: :any,                 x86_64_linux:      "56208b282ebdb0ab5d5ec40ccc828d4f71929047fd8fbe773f13e03030a5277f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "rust/crates/ccusage/Cargo.toml"

    # The `ccusage-core` build script embeds the LiteLLM pricing table,
    # downloading it at compile time unless CCUSAGE_PRICING_JSON_PATH points
    # at a snapshot; download it here from the revision pinned in flake.lock.
    locked = JSON.parse((buildpath/"flake.lock").read).dig("nodes", "litellm", "locked")
    Utils::Curl.curl_download(
      "https://raw.githubusercontent.com/#{locked["owner"]}/#{locked["repo"]}/#{locked["rev"]}/model_prices_and_context_window.json",
      to: buildpath/"litellm_pricing.json",
    )
  end

  def install
    ENV["CCUSAGE_PRICING_JSON_PATH"] = "#{buildpath}/litellm_pricing.json"
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage", features: "fetch-litellm-pricing")
  end

  test do
    assert_match "No usage data found.", shell_output("#{bin}/ccusage 2>&1")
  end
end
