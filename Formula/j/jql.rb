class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v7.2.0.tar.gz"
  sha256 "c190bfa3bd3f655a695598d9fd0281116260d1273b1b180d6cfa7b8f35020523"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9235890567bf72cc10b3fa749f57479531df7f3476380119907e6aafa4c3ca5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ff0e7b89673c1cf08de212d06ffadf0c7008a348fc76063ef877e293b14d318"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "653bd281f1650cc1b3fe754bfb9498b5adbdf8a5efec5a813fede1ab7775f3b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc50effe5415d7e1b0f073b87ffe80e08d4ae995bb3a21a6724bb6173d41cc58"
    sha256 cellar: :any_skip_relocation, ventura:       "c90ce978e53ef5c4fcaa4f5a33fa3649ac55e3679f87278a97d10a5d3b2f68cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "446c2d2b60fd826e1d205bbb3a339e4855e9d5c7edce35613296255ae4e13b41"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/jql")
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    EOS
    output = shell_output("#{bin}/jql --inline --raw-string '\"cats\" [2:1] [0]' example.json")
    assert_equal '{"third":"Misty"}', output.chomp
  end
end
