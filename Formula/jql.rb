class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v7.0.0.tar.gz"
  sha256 "550ba37591dbca47024b25c482dd478e5a544030600d547ce61e754b579d6816"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "113ed84e1be146c6c6732663080cec36669de21af74dbc45117bf5371d341a22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0eb19adb083efbad730311a9bafb84c9895052a0c115ff847862cb8371d2222c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52e067fecbc14b3f9860732df2943d25049f7f390aebf976f0984d071d2fef13"
    sha256 cellar: :any_skip_relocation, ventura:        "1e70f0f35c6984e36c1986298c61f24884e4aa08308787081e62478f5569e2e4"
    sha256 cellar: :any_skip_relocation, monterey:       "b31ccf2d563f0abd08bd738db985b6de0c5b9994f5b98e033e9a2e16f4427418"
    sha256 cellar: :any_skip_relocation, big_sur:        "af653997fd93426de9c4d9141dba2147384cbe2183203fe9d6aa8126eff2bab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07a83c304f8510f0de981ad02b5b1174b26ab26ebb1160318241534824c6b4bc"
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
