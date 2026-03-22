class Models < Formula
  desc "Fast TUI and CLI for browsing AI models, benchmarks, and coding agents"
  homepage "https://github.com/arimxyer/models"
  url "https://github.com/arimxyer/models/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "370604b5a1ca01d1aeb977870cc16d526c7d6e4803db51279979c4869707ea5c"
  license "MIT"
  head "https://github.com/arimxyer/models.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f2051ebae1aee081bec53e5c244cc4b4e2a9ebdf8378a4894bcd1806cac64be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43b8c3d36f7497c1b6aa4d77030468e663fe044310ee1ffda0635397419d2bb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6faee0b3e71844f2c42c4986c0a35e705429c66affb52b37eb750ac85fefe05f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c24121086231e4e0fc1aae1e785894483491f81e7f094d6756909508bd2943b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b55efd2b2aabd86cc21fa25fd6927c966f30b59e238a4301c76ac416d82f25fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cb4995fa9e7ea3b874dbfe42c0d893ac313a7592121c7f3f570abdb45a59cfc"
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
