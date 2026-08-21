class Hayagriva < Formula
  desc "Bibliography management tool"
  homepage "https://github.com/typst/hayagriva"
  url "https://github.com/typst/hayagriva/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "bce8393f5200a3672b0d5baade84cfd96646dc7f0e045faedb0bf9a754c1a48d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/typst/hayagriva.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe73f0cb1bcd86df981f4dc34eac4952a334b141e53479bda7dbc4e79340b10f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6ce4a16d244963e5daebef03c58ba5af2c8581d63acedebf3ca60bcea3120cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c48db9430249c955a0364a1f84f5048bebf3532cf3d17f9ef9a21b007424dc7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8eef82c78b7a5390fbf01b3d20745e911bf312200852bb3d562b2c8a1d48d442"
    sha256 cellar: :any,                 arm64_linux:   "f65fe0f01950da5abe9b8a3b2dbeba15b37d511cc78ac8716f0b9523d1cfa974"
    sha256 cellar: :any,                 x86_64_linux:  "e5fa9bdf3ae7affc7ad76e644b7d60c41c1cac7508b2a07ad3349791b11b9567"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(features: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hayagriva --version")

    (testpath/"test.yaml").write <<~YAML
      dependence:
          type: Article
          title: The program dependence graph and its use in optimization
          author: ["Ferrante, Jeanne", "Ottenstein, Karl J.", "Warren, Joe D."]
          date: 1987-07
          serial-number:
              doi: "10.1145/24039.24041"
          parent:
              type: Periodical
              title: ACM Transactions on Programming Languages and Systems
              volume: 9
              issue: 3
    YAML

    output = "Ferrante, J., Ottenstein, K. J., & Warren, J. D. (1987)."
    assert_match output, shell_output("#{bin}/hayagriva test.yaml reference --no-fmt --style apa")
  end
end
