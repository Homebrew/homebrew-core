class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v7.1.13.tar.gz"
  sha256 "eb558535914ea28ab39761c0a38f22e46e6a24c2f82d2a930cf003e413c7458d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43c2b25f37773cd138b96c64417cbf5398543ec590dea641354801dfb7f37607"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b67fb9e6489db2bcbe4e829ac78023ab133e28b14edfc7c29ce2938b390a8a77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fdcb4c5ebdd35d97aa95a497e96f9fc9b7c1860f174de5511476910641dd783"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c5d83659fcc2427f6c48c4c021dffbf2af09c5b29828cfa2a60d46d051e6ef3"
    sha256 cellar: :any_skip_relocation, ventura:        "5607da72b1197888d3252746607cb3a14ccd98599e2473b27193d042fd87a5d6"
    sha256 cellar: :any_skip_relocation, monterey:       "0ee50c46102e5d705a65121afa92423d913ca5bab09dde294c62012edf201fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d30df7ca8842184d2dd77cf3f7dddf20b82b11273439bba80d269571493d12ac"
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
