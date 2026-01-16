class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v8.0.9.tar.gz"
  sha256 "ed754f2d13e396b57b9108b219a8d6ada1d49ec92a076e84cbe6565b2b0a9cdf"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62c4b7855b6f53085354a250ed3b805e133fae9dced8184059913b9563466af7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4cfb6d984d382be271c3a304ab7441005f1b6b1bfa9302e40733be93e3d3291"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1da1f7a58c734dd780047f611af56f40ba4b87ca6ecdb94073888fde38b8ddcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "be7e5d33a5db9654cce0da85c40ed41afff4a62b0b31b150e10e224c011ed98c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6785a79806f3d1e3b83ae801ab3a35711f767f83504887650898249b30182739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2939d5472dd80755ddfac42bac2ac044606eaaa0ae4df6665d5561da19003e3e"
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
