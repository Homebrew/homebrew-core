class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v7.0.4.tar.gz"
  sha256 "a6f0998865ce00d48ba94eff12d3f7389dfe2d6ce0954296fdc890c9157628a0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ee138e617fe26ac28201cf6cbb5d49e71bcae0d90e76aa9327206889abc25db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a10a53b05dc7306b679be24af743a02f101bb2fb668732f4569304bfcfe9a70a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47133d3dd3306ba0a810c57e8ed18a28e08d8c8a0044b37ad600229f991d5059"
    sha256 cellar: :any_skip_relocation, sonoma:         "b57ee0c03aae42940939c690d082bbb7b1fc08b2b87c76552105700507f7393d"
    sha256 cellar: :any_skip_relocation, ventura:        "894571cc108bade69867f779dbe628ee7f86ed0d258d719ca0ef420087f76ddf"
    sha256 cellar: :any_skip_relocation, monterey:       "6317a9c4f99d88977e5ccae60fb10c356c437b67c7987998c8a9f65330ff7cf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80a669b724e433c73f5bda232453c6dad040deed548d2eb98e94a2672e58022d"
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
