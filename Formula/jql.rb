class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v4.0.7.tar.gz"
  sha256 "83ac87277c0aef4559fd330a99b4b462f4a2158180ef9204083e7c1ce247e344"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd95c9258d55144d2b8477ab25bd76fb22e63265df53e7dc2528e7fa71112aee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3f545478133e159c7408873e21387029e74346430192370b1328fd0d45b7af6"
    sha256 cellar: :any_skip_relocation, monterey:       "62dd9e5aa4036aea13c66742a52fad9cc4ed1d9444fc24e5f11370de9e29845b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9b89f3502e7468f8f4f6775c5653832bfe250f0a6ae442c1de98281d810937b"
    sha256 cellar: :any_skip_relocation, catalina:       "7f0ee0bf02a6e861f98867d735aac7e08e707f0240ca0a77d4c6b78aa2941341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c56c6dc63cb073c9dc4499a7ef9bf064a307939db186232f28317cf287292bfe"
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
