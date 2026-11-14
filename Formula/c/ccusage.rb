class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.50.tar.gz"
  sha256 "07aa5fe8b7f53386b108fe7bba25f4610f52e391d6388ecafec3fcd43aa6c72c"
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
    url "https://raw.githubusercontent.com/BerriAI/litellm/95ecfbbac60091dfb665e73c5f0eb7ef8ed899d7/model_prices_and_context_window.json"
    version "95ecfbbac60091dfb665e73c5f0eb7ef8ed899d7"
    sha256 "4d9f67ab0593c98c989b222d5290508e58299c01faa746517037dfa5b8794088"

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
