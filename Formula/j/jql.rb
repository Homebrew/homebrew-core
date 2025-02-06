class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v8.0.3.tar.gz"
  sha256 "ec4f9885b42316610857a22d6ab0a1b752187a8d858cffa2fbfb2b104b96b978"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "894506c8e8459dbf12221a4c0fbeb353c7e3b998f4a0cae26f7eaa30ab3b5625"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fe35fa7773271b50c8019fc56d37e7f49af7ef28af7fa51b294d55062077489"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f6e6672ec6032b276f0782142a6fd18744b625e7e98536ebff20ea29918ff50"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd09cb3b5410ca2cbb06d8e7c3456e516a1275328474e9418cca50626800792d"
    sha256 cellar: :any_skip_relocation, ventura:       "60554e079754bf5223458107e10ecb249c23adcba02b98007dd0eec910e644ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20baea27c6d37077c9a596e808de2f30b8711e4bac52038430dbd613a969dc00"
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
