class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v3.0.2.tar.gz"
  sha256 "6573e1301e178fe57f8d97fe7b299b9c0c1ea4cdf690d6d19aa9d20eeb3ab92a"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fb162a7cb247f40c52498cd3875a24d99eee60ee28328570f041bb3079f16a02"
    sha256 cellar: :any_skip_relocation, big_sur:       "c4a0acfdd953f1559b78b98a741cc1f0b6469c4c9f54af90862d7a7018542f3c"
    sha256 cellar: :any_skip_relocation, catalina:      "5ccd6b90708480e1e65dcdac74be64fcc7ee321ac4599341100cf155c1a152c7"
    sha256 cellar: :any_skip_relocation, mojave:        "36dbf0891c438b561940411f0a0d9b95bac145fd9fbb8e825d75e5967278dd08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41bf21451c2f959265073f1755dcfb1d6898701094c97b78b41c3874431de549"
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
