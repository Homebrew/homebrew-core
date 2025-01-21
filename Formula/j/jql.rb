class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v8.0.2.tar.gz"
  sha256 "3c591dc7c1f2459d581f3373f0aa81593dcc2596c88078dd851f2f84410dc054"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1c986b912eebf7ee54e20b723d23d7232b8ef583b16da4743781ce8fbbb7f3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c932e46d8b95e80634e12eb24727ff0452f569a9e5095a336e18acf69e24c520"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b716e95d4dcd3b2e979e2e82b52b1397a5451e008ba156defccf2e4368bc956"
    sha256 cellar: :any_skip_relocation, sonoma:        "6eafbeb00df2b5c49b0a150c0dd8314c926e7d2861ac514b8239ad376f00882b"
    sha256 cellar: :any_skip_relocation, ventura:       "875d17b55bb8a148ca2d1d317a7b225252c8fa2d956adf85ec8df6f96da86205"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47fa8022b0edccedb11ee0a55857b2c0e3690410dd78b0f5744446889ecb0c47"
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
