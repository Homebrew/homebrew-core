class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v9.0.5.tar.gz"
  sha256 "ff717f7966b4ffdaa78ae04f89b782ca380de67ec997672652dca3afe096c1d0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    manifest_sha256 "29c8731980dcdb7c2530b8cd8b3fc523f9e1e654012d3e1607e17ce366fa2ed6"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6eb9b5abee328f4e51cd5d37947f9851bc3d487a0097b4c656f30fd7230a9100"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bf4743004ece1b8a8ea1fc81a201671be2012562c4646f9fce0d3fb33e9fc115"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4335b8ca5b2dbaca1e48652405a169c5d027aa5f4b10013a4f73c56665909dee"
    sha256 cellar: :any,                 arm64_linux:       "48f636659d98b0906df0dd6dafffc6c0d7d218bdb76aa34ca16bc83d3a248700"
    sha256 cellar: :any,                 x86_64_linux:      "4019fa07998ddcc10116e935b7e69bcb920d6c9418754f28dcd77ef1cc1fea16"
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
