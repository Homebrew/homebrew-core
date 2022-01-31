class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v3.0.8.tar.gz"
  sha256 "fd26ff64224c2d57b6325aa64bc30210240667f3a2a14d5c1297dc707d91340e"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68e16ab0dde83d560380df9c23de898d4a1f744ddee6119a5b40be497fc9991d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7413175f25c7926e7f5ccf0bc116818a1e69a98775fe7d0c8f8032e0e3bb7ab"
    sha256 cellar: :any_skip_relocation, monterey:       "242c250dc89dd51d105feda27c38a5e6e6725b2968d33c278876217c990207f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae53c4b66cd62b1eface99f57f56687404d14b16922208c8090de474b6d44606"
    sha256 cellar: :any_skip_relocation, catalina:       "300e355b3129d22e60f80fd97bded79d69bda28461ef81c684fe1aa5fbee4abd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "098e3d4fe963b8ff7e42a6b0bdf8eba553515a6f3ed1f7de58e27f6490da2701"
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
