class Hayagriva < Formula
  desc "Bibliography management tool"
  homepage "https://github.com/typst/hayagriva"
  url "https://github.com/typst/hayagriva/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "91d451608e96b3e06fe98d6bc20915b62eda69ff4fdfdbb2ae9b098eeb11a690"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/typst/hayagriva.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a475268a6565eacaa5769082f9b5ee72c3e97db28904e84814a293a995d181d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c05d797995085579f3695b117e3505b6a2b0fd713fe56ab5837faae6e693bcd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88ad9108da04d8471f9cbb595e063ca12628fc7b0b8ee127d4a9d429df370fd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bf289411bddd3cf2b85a82c9ac7d04bb83b991bebe90a3c7c5d52c1525a10b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2a1167e276da83099461cf680c40f6997754a0c21b8f2ebf11fe8c2bd80f59f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c70d107b3baec8eaa3eafb8e7dfb42895fd9fec00db985f9dbcd64efeffdf30"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "cli", *std_cargo_args
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
