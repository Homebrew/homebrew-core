class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v5.2.0.tar.gz"
  sha256 "2908caad0104bb34ac7a4b49ca92ed97353d98db05d69885b51dfe68556b3052"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d34d879e3ac178887c5f327985049bd1d41053d5553cf45b37d26e8f0241cd46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c613f5cae2abae621a74ab7f2c90c71fafd89a1feb3c76240be7229b9fe8cc5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "716430a27203a0ffc8554dd445cfc75187d2b07b7e442116fc4680226ab8cbab"
    sha256 cellar: :any_skip_relocation, ventura:        "aa925cc341cd5f3cb7223196be99b7bf87036be6a4548c0b76841cec499c2a2f"
    sha256 cellar: :any_skip_relocation, monterey:       "d2108f57c6e05282f313fcb7d87fc82d1a5c8c86890c750c4d251bff47722bb3"
    sha256 cellar: :any_skip_relocation, big_sur:        "41c3abb5effb2c0f60895433bb1ca973b762447028b6eae4bc9aeb61b7acffe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7eb42e5f065e5592fdf24d2ca0dbb3c861f1dc64f0b011d76100c02c7950d0c9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    EOS
    output = shell_output("#{bin}/jql --raw-output '\"cats\".[2:1].[0].\"third\"' example.json")
    assert_equal "Misty\n", output
  end
end
