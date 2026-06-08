class Models < Formula
  desc "Fast TUI and CLI for browsing AI models, benchmarks, and coding agents"
  homepage "https://github.com/arimxyer/models"
  url "https://github.com/arimxyer/models/archive/refs/tags/v0.11.52.tar.gz"
  sha256 "6cffa057f13c98aa087986c80cb7b58220c6fe6d2116e155cf7d661f2bd1f1db"
  license "MIT"
  head "https://github.com/arimxyer/models.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83f3837f82c2f40315fddede4bc19bbc8c7c928c04607222fb4603629b4c7cca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdc1753d453f64068da0aa5cd890d76528ff569bd11662961ef57ecb16f2dd6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "104f854376a710178e7dd876acbd5f0921ee6c21b9ad416e04236b9baa92a2b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "47ee516d5ba2e2bba4dfae4bb29fddd652478c6c904806e7ca034dcb3ec6c437"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26a7d460c0e058013858cf2d7536b053a72206e6de261d06642596869c750f7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05217af72744e8ae39c554649499182181f0810ac23b23e115f79f9e754edbdb"
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
