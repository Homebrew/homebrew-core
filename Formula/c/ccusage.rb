class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.48.tar.gz"
  sha256 "873850969ef9e225289772bcaa3a8bab0bafec9b57ec80db3d819b2b139d164f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5346d7613772baa6df621188e2bd9aa3188aeafe819a4678543efccfcaf1ccb5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3a6de35dcbf9791e0f0c169e78d1771f78e4057f035518f48c1a63b99f89bf1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "44b4a842516ec4d614d519ec9bcbc2f55b360351483488e194b51ccee18a49e9"
    sha256 cellar: :any,                 arm64_linux:       "8b6dee7f57afa0745c8d61d83e08834a4643492a797fcb2767a762a4b8a764ca"
    sha256 cellar: :any,                 x86_64_linux:      "6e34156a2b77bc08442ba10657e9ce6e31ea226c9e2cb071ae6b94c94ed48287"
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
