class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://github.com/urwithajit9/evnx/archive/refs/tags/v0.10.12.tar.gz"
  sha256 "f7890db5c61d8e87babfb32a780440d51f882e51263d6d811bcfdffd0a3b1953"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b4c212ea773a1f960923ef51fea5306bfa2b3a3658f4c9cf087ee797eb503a03"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5bbf27d9a7e342187af3c93caf39a00b4bce62d5e6d6da7458bc9c48465b60ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5882db974d1eaf4aa2776ae3a8d4f9a07d5497d12d4770ad05dde9ec9ba4acd0"
    sha256 cellar: :any,                 arm64_linux:       "c5b5bf41c9649bea0b56e42b2149a20122a4cf6cb835086f30f2df2882314a69"
    sha256 cellar: :any,                 x86_64_linux:      "8c2e2aeecbf39a15eee6307658f18ff7de7ed4f1b450313fa7fab6efcb73b26c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evnx --version")

    system bin/"evnx", "init", "--yes"
    assert_path_exists testpath/".env"
    assert_match "All checks passed", shell_output("#{bin}/evnx validate")

    (testpath/".env.example").append_lines "API_KEY="
    assert_match "Validation failed", shell_output("#{bin}/evnx validate 2>&1", 1)
  end
end
