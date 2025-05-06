class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v8.0.6.tar.gz"
  sha256 "8af2f6c794cffeba9bc2604cf68cd7ddaa6126ec038786060b463474e8a88b5b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6860a78f88ccd0e124b2bbbfa76708fdebe1914ceaaa250dedfd9f67815d56f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "225736c377075e9be9729971fc07a841f9d1e4e4da3620483a671901a3bbbb9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abc6c4a072ffee1cf7636a9999883b22d95a64958e2c6a12da3e00b7ca07c5ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "4307e9108391a1645b879d2a1f62fcf037da7479d468b52af69a76b42918cf05"
    sha256 cellar: :any_skip_relocation, ventura:       "697f882b3ab3a92135f9f7275abdad329ed1d14a2fefebc807a24f837696db4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da2bac1654b7d3f89fab1a54e01f756b36de4618db8074ccab83e4e9127d185f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a247dea0d088ee3a9262d80e9ceb7b204209a6bdddba5bb98ce72aea24abfde"
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
