class Models < Formula
  desc "Fast TUI and CLI for browsing AI models, benchmarks, and coding agents"
  homepage "https://github.com/arimxyer/models"
  url "https://github.com/arimxyer/models/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "c113821eba94b82d1e98f5590c8be1cb4aa39ecdf26bf9721a5ccbb704b433da"
  license "MIT"
  head "https://github.com/arimxyer/models.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae60fadcc06c3ccd7a0abb9afbab2748ba96d26f7661f31cb173520cffc2d759"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a55c7045a5a3d8e9f36f9564a67465545af301450ec3a707442573615288ef2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3b1ba2c5162bbfc8763681c19c878d3ae938c5ac0ba1674c906619b9e16f024"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab462550a2c3ceb52f9ee6795a54057001611dc55f4995155733bd9113620eff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9791382e9d2d3c54a49dac9dfc78942930e4583319e945d3c074546aee5296f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b7fafc81d0e637221039b32010833186dc40543a3af4586a65430f68d0e116a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/models --version")
    assert_match "claude-code", shell_output("#{bin}/models agents list-sources")
  end
end
