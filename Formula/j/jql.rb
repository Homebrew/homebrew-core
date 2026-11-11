class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v9.0.4.tar.gz"
  sha256 "ebd9ab1d91f7cb6efd076b55fa6cae4696360f3b7e1cd77b62173c14d6b5e50e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "766cfff5490dedd176da133b7d1bd85ee4cea29e3efe31f1842a6b951e39dc84"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fbb08c2ed696f8be18690a0cbff56845f2e34c06c5cde1684e779e861fed71d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ff4533c0bb0eba436bd385ddef729bb254b53e2c1a492f9970ecaebf761080d6"
    sha256 cellar: :any,                 arm64_linux:       "9e30158b8fbf02816db59f14386bbd853b0ee4e52f19a4013f108449a5b65f9d"
    sha256 cellar: :any,                 x86_64_linux:      "60a2a01910517680e7103ddd8689a58f67556408874ab41c67b9f98366beeca4"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
