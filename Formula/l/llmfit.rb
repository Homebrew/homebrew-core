class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-1.1.17.crate"
  sha256 "c96f02f0d76ce0637914bd1c54787624573e8e5d1301d337db66f5e6f12e6eb6"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "28213e3624ec55b5d7845bb30fd446fb2ccd08de9ba03e3ae16dbddea623c1e4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "518102d38b30b74d5253897e83192f53a76251d2b2713547235de325fe8da0a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a7e877a8c411b190bfcb08d4db9abe534b4cb66ea0f3fc8e2ece02a1fbd52ff"
    sha256 cellar: :any,                 arm64_linux:       "610e1e2f166c2b2cb32f291acec81c3c52e8ea33ac7a507959c992d6b32be814"
    sha256 cellar: :any,                 x86_64_linux:      "823b192f0aba28c06c2d0f4885ac9e2605a447fb811bdbdc1569025c21628102"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match(/Found \d+ model\(s\)/i, shell_output("#{bin}/llmfit search llama"))
  end
end
