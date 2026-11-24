class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-1.1.21.crate"
  sha256 "33b841786bde9c052a9e44aebeb0db143157303a1f60db71acd9bd7005153305"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    manifest_sha256 "f7999ea332ec3381ed18d2364c51f08d37f5704ea20f4748956356db4cdbdd56"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "42e69b416b36890726080e8f0380a6662b2e6fe291f2d5f26b678ff44e875590"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "68fcfbea33e690fdcac30a3bfee80cf3a9812c6d804ba15a81b9613d6ab6a5dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "750f23dfb18dca18fc455067a21c875872b32ac254b280cff4dbfee487f875bd"
    sha256 cellar: :any,                 arm64_linux:       "a51f9a6ee25e9401298d9ac8c562c529497634ed2cd4bae462a3e5b77b146c67"
    sha256 cellar: :any,                 x86_64_linux:      "df087490d0539b7aa27ea7b3ab60493f74c5ce91b891a11ed8f656795b478db7"
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
