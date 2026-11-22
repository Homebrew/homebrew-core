class ParallelDiskUsage < Formula
  desc "Highly parallelized, blazing fast directory tree analyzer"
  homepage "https://github.com/KSXGitHub/parallel-disk-usage"
  url "https://github.com/KSXGitHub/parallel-disk-usage/archive/refs/tags/0.24.1.tar.gz"
  sha256 "cb2c84ca8c98124890cfabf10e48ce6ff5219f240d2f3b6ea8d58d2791c295a3"
  license "Apache-2.0"
  head "https://github.com/KSXGitHub/parallel-disk-usage.git", branch: "master"

  bottle do
    manifest_sha256 "f38951fea06ff2b7c928743f85f3dc4bde429907bbfe1262c9f76e03be9d7a22"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cc4cf4da003983ba85c00622eafea2fde6e268b2f24b112fa9f8123e77183216"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6cdf80817b3f807e89121d04447241ee2956a7f6b3f9c81563f215698f79569d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0533fd9cff152ca5dec094dbdbe77a1ab40617c9cc59f28a6f2b9509c67d34b2"
    sha256 cellar: :any,                 arm64_linux:       "5c9856b6f7dda2c476d060e449c22712a09fbf58d67c89cf7e22ba414a857951"
    sha256 cellar: :any,                 x86_64_linux:      "04db1fc62e565241da7f386426b0a0632b35ab1edcd1222c83b2c1b0e0aecc53"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "exports/completion.bash" => "pdu"
    fish_completion.install "exports/completion.fish" => "pdu.fish"
    zsh_completion.install "exports/completion.zsh" => "_pdu"
    man1.install "exports/pdu.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdu --version")

    system bin/"pdu"

    (testpath/"test").write("test")
    system bin/"pdu", testpath/"test"
  end
end
