class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.25.tar.gz"
  sha256 "67fb7d06af4d46f31391381a58e3f51cba6480d34b20a561b288cb95093b5478"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "910fb1d30a51d5b08e04e7349ba8cf23d8f44433959263f6122485c67407255a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "edec62abebc3745c53e512e38b150e88089357920da93bc08c61cdca9dbee2a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d3679153d327417b80c7d8c8fd5c89573f547a0aaa282194165b6e885444cee3"
    sha256 cellar: :any,                 arm64_linux:       "93da6373fa1c83b070f147f7b0bfe4a8664f3ec6462ddbff77c7d327e3e79a0d"
    sha256 cellar: :any,                 x86_64_linux:      "309523d1afece1ef00ac9f6767349324daad9d03ffc15c30915723f1f9c5598b"
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
