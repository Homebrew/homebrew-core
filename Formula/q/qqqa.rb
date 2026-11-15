class Qqqa < Formula
  desc "Fast, stateless LLM for your shell: qq answers; qa runs commands"
  homepage "https://github.com/iagooar/qqqa"
  url "https://github.com/iagooar/qqqa/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "b7360c786ed2dba34426d1dde44d669f17570fd5f2205392eaa8d2e789cf6a3c"
  license "MIT"
  head "https://github.com/iagooar/qqqa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "301de9c3d5cd100268b535f98017100ddeccffbad22b48402249ac9b08d231e7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "465127bbe5e08e26b9ce1e561a6139e81b3f107299aca1a083923fbb245d1291"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "58adde921b57437b9092344b008902f22ab456a0cb778b43152c7c926abc65ab"
    sha256 cellar: :any,                 arm64_linux:       "ee18c3d6a902fa8c665e294c285917cd142061bdd5345d8c573e0bdbfeeba725"
    sha256 cellar: :any,                 x86_64_linux:      "990b175b655da9fe1d1b78fb02a9d4b159440bad9059abc44a5cbe0f71f7485b"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    # `Cargo.lock` is ignored
    system "cargo", "generate-lockfile"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    %w[qq qa].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} --version")
    end

    assert_match "Error: Missing API key", shell_output("#{bin}/qq 'test' 2>&1", 1)
  end
end
