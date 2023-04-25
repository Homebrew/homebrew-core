class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v6.0.6.tar.gz"
  sha256 "a4907ecba6831ce9c3ac2708b1d1fdc08b8a65206a30148f81d6e551dd09c02e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed0d13f03c68f31132d6c8c17e77b724dcec3ec088301992d56c86ad29a96613"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d608eb8aa307e9cee602157d51ef2e548499f3bd6235c3b0e716462c8cc4300"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67d9089c23cb40239ba3fbeb0242cedb3263b7dde878a400b5ed8a0acc7e127b"
    sha256 cellar: :any_skip_relocation, ventura:        "a39b13cdf44932a17f9445dd7cc6716cd751f7aa281fa5d8f666c2e75bcb3db4"
    sha256 cellar: :any_skip_relocation, monterey:       "27ac4b0bcf619ed1622b2a852313c6bbea4d274b4131cdb8d520f4b33105fb13"
    sha256 cellar: :any_skip_relocation, big_sur:        "df45583945d5483f06f51c28d4ddb838fa5de3b4ef11f7903e2f6ba55c97775c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06eb8999180eea9b069cf12db0f8039983a0651f162f9f0c0c368fd46de57f74"
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
