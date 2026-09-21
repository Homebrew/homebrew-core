class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v9.0.3.tar.gz"
  sha256 "271d340c39fb328eb22d3a1dd5151be99f1c38c2169ea28d5f9ebbdd40e4eb82"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "62a168b0ee6be15e07ba7dde4f3532a18b9a011efbc2174b926cf3b64498c161"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6852f94ca1599bbd3c7028b19171fe2772762632077f75a4afa76cbb30b3afee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cbcc95c7921e73ac7b4fd1c8294de6e82570a64b682799c8aa39b2f925a519a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "cb54fac75fe587de969a5314f7c538ce9cac9245a1ffd477c6a971512b311d07"
    sha256 cellar: :any,                 arm64_linux:       "2ebc2c2bfabf14dc439b508d26a5df990123b610dc566e9ab406c5b1c6909f1e"
    sha256 cellar: :any,                 x86_64_linux:      "9cb385e3b7966fbcbc87c0f6990f922d9b46668de5e69c9d7e57a9894145d366"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/jql")
  end

  test do
    (testpath/"example.json").write <<~JSON
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    JSON
    output = shell_output("#{bin}/jql --inline --raw-string '\"cats\" [2:1] [0]' example.json")
    assert_equal '{"third":"Misty"}', output.chomp
  end
end
