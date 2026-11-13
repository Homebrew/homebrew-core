class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://github.com/urwithajit9/evnx/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "45e83c082688e1a471af999ad5590e2e1f69a9d3001e8553b7720e214b9c81f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "53bb8379941cd2482197318ea7358a6cdb39193ed206b1b4895b4fee036b9313"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e041c2c03f23255f077db6990e0736f237395ba8c34966e97c38d0f4e1ed37a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dfb4a8f9f28150ea2f80107a670017998f7351275fe0e9b91f00516742e0293d"
    sha256 cellar: :any,                 arm64_linux:       "b960bdc4562d0d40d7a9f7168540e8ea2af5e0994bf6261efe9e2cc0163ac7a6"
    sha256 cellar: :any,                 x86_64_linux:      "fe1263183c4e8866f3968f2a1e600f08785e6e9b999e85c0bfe3164c64e5adad"
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
