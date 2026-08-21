class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v8.1.2.tar.gz"
  sha256 "a8d76cf0d6c15988034cb186975fb0da360041e59350b2abead52c7801747315"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a82127900b48ff5cab1b78b1b1a4f502491aaf7a5c9108cf5f40774e3ce3a856"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0af5b5ae39fb698d0d51505b252a69c7608ad9c01493307fefd7cb4a9bef26f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d53f0562177b605d34917aee2b142c63ee92e9bb9fce6adab96f1605ef017eea"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5460290197caa35f2a9f4bb0624fcbf5090efb45073a8a37821ffb3dab7fc2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dcc62490d154fe8bca6ef6a93aa42a69fdff2c9910140afa16df7366941f1a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de3883d7e0ce9eca2dafe0a3e714b38cb16257786cbb9186e28c8772620d266d"
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
