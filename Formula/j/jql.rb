class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v7.0.3.tar.gz"
  sha256 "fb663b4cda225cb4199afb5aa10e5657a2ca12a006cd218141ede8278772d9b0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87f5fb839d66f599ebff9c3a672f6b61ead4a5a429ec85c741f27c80162f4743"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25fd205bbbbda78c02e1cec459525cfb4488653ef7f343f2dd6978324b4f2216"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e758d6c7bc7b7b8f1dea09d6af8a232350535b83000b9f98ef8d284a1128c652"
    sha256 cellar: :any_skip_relocation, ventura:        "6644120c2c9032bd93122cdc302247fb93ff2f8ecb24a4b95f1480f6e0b8bf6c"
    sha256 cellar: :any_skip_relocation, monterey:       "4f03a3cbbcbe777fc6f8d49c5611297e1a4e0951f14310b7e84153c03d0282f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f52f4bac83cd3536f8073f596dce4097d9b6bbf4bc537d25e13b4619a85ab79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a96ebd2a160fdc1e8ad9669ca8f8afd3da5788cd0c4fb93515f7ec00fc36149a"
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
