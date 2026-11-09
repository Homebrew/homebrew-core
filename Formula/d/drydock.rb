class Drydock < Formula
  desc "Dashboard for a fleet of Git repositories"
  homepage "https://github.com/yetidevworks/drydock"
  url "https://github.com/yetidevworks/drydock/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "a22ee71cb99f98b6f3d2b769cccd7f629323c9f3463cbe1914de95c6042da229"
  license "MIT"
  head "https://github.com/yetidevworks/drydock.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b64083e13057ecff4908dc93ef6d1696ef9cbe80a5206b8162fe18662d3f9295"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "48031263be2ea117ef5b652fe54b6a55582fafc967dedbe47548d1ee513d5dea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7b3d548a0ecfd4a36397b71ef74c65cb2f405cf8543799a4174b6934aea45907"
    sha256 cellar: :any,                 arm64_linux:       "3e7c47095645b454cb6d1930e8590c489f4e613839d9e5f8cd8f8b09a4ed1560"
    sha256 cellar: :any,                 x86_64_linux:      "1e42929e6cc23df4c4c3fb57abbe1f1b6f8c46fa34a7a0b4caafbb0beeb9223b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/drydock")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drydock --version")

    output = shell_output("#{bin}/drydock config show")
    assert_match 'roots = ["~/Projects"]', output
  end
end
