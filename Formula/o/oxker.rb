class Oxker < Formula
  desc "Terminal User Interface (TUI) to view & control docker containers"
  homepage "https://github.com/mrjackwills/oxker"
  url "https://github.com/mrjackwills/oxker/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "f591972106d66b22184fe412327ca1419944e925914fc71c9c2e43528f081827"
  license "MIT"
  head "https://github.com/mrjackwills/oxker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77d43d9d6e0d5278d18c7a06ee62a738c3c17e7fac59cc69fbdf2409b29aed8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e9c37b382020ebee1f3559f288e899c9d98150bf95d42d1511aaff2c598b5fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0001b64392eaf1f785af4869f218bcd500765aae9c10851a46282b5c27494e39"
    sha256 cellar: :any_skip_relocation, sonoma:        "aab7d16eaa36c72c97077643aeddf0469b23e94fcc53b708562df57656b8a11d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b99d3d323f045686d2d7eb741090c194a02cfd9a927f6832e0d934c1908f87ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8328843e0fdd710d20336f11df8db40c905584377cc6dc55d94dadfb50be9ddc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxker --version")

    assert_match "a value is required for '--host <HOST>' but none was supplied",
      shell_output("#{bin}/oxker --host 2>&1", 2)
  end
end
