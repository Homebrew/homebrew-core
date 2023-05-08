class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v6.0.7.tar.gz"
  sha256 "703419dac3136fb9e96e2fdcd480b5802a0be58aa563c655e7c1a4f16dfc9a1d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a7c0da3cd966cf8bca15e6e74e3ba918e5bb5e993145b6519d8f45cdee67dda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a063200553dca5d31a934a09a242523b4de32d911ea937a8857685ce04cbf9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92647145cf672fe85a38459ab5f306d1b1439c1b2144f8253656b6cc7131138b"
    sha256 cellar: :any_skip_relocation, ventura:        "a45e1240540694630b67f2cf1552758a0044a87bc7fbdbd2cb298c05068c10d2"
    sha256 cellar: :any_skip_relocation, monterey:       "40b5b526f61284320cf9db53a94d892d6e74cde70232b7b027c7dde38062a49f"
    sha256 cellar: :any_skip_relocation, big_sur:        "862f6ce276c3d49ec311dfce944789ebc9602cb1a33b7ebf8c82f1ee3d1607d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "048e41c2e11adc5d0e6dbb2659acc2bb6a9240662cc19b2e2d0a3a107a90571c"
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
