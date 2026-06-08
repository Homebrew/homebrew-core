class Hayagriva < Formula
  desc "Bibliography management tool"
  homepage "https://github.com/typst/hayagriva"
  url "https://github.com/typst/hayagriva/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "41c82a16510cdceb922250e2f133227759c6ee1ff05bef5328598b97f7168edf"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/typst/hayagriva.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e145248cf6e3efebd63e551c10c32016fef8d843eddbde3ecda31df77bb4675a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df21ab35749023c7fd5d3766fecf09d5715d6dfcd69c36bce669b400120db40e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1450b0f68037a4c6675b1a4b5e7abad8b61a3fe3ed8039bc30ed29626a90904"
    sha256 cellar: :any_skip_relocation, sonoma:        "08bba4d577b45cff693d9aa6207dc593a12aca1e1c6277908d08ef2c79391968"
    sha256 cellar: :any,                 arm64_linux:   "5f9a523876628a46f43a1e3edaba7f4f38a3930495fa320395235f473feb8085"
    sha256 cellar: :any,                 x86_64_linux:  "8e33140c93c79ecf81bc7a709044acae177667bb0e47db14b99f648e355522f2"
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
