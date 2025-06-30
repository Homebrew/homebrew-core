class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://github.com/openai/codex/archive/2925136536b06a324551627468d17e959afa18d4.tar.gz"
  version "0.2.0-alpha.2"
  sha256 "314bbd1c705e2262d146d4924bc864fc3e61293b5cb27bbb94306e1c64c4e6f4"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "754cf31c59ec4bffde64e85e00a5e4de09400cb29aac35bf86003922e764b987"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "754cf31c59ec4bffde64e85e00a5e4de09400cb29aac35bf86003922e764b987"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "754cf31c59ec4bffde64e85e00a5e4de09400cb29aac35bf86003922e764b987"
    sha256 cellar: :any_skip_relocation, sonoma:        "16d121f1f81e90c950fdc5b8b9bba62ab1c3445fd7ee5d06882e39e799535a16"
    sha256 cellar: :any_skip_relocation, ventura:       "16d121f1f81e90c950fdc5b8b9bba62ab1c3445fd7ee5d06882e39e799535a16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "754cf31c59ec4bffde64e85e00a5e4de09400cb29aac35bf86003922e764b987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "754cf31c59ec4bffde64e85e00a5e4de09400cb29aac35bf86003922e764b987"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--bin", "codex", *std_cargo_args(path: "codex-rs/cli")
  end

  test do
    # codex is a TUI application
    assert_match version.to_s, shell_output("#{bin}/codex --version")
  end
end
