class Grex < Formula
  desc "Command-line tool for generating regular expressions"
  homepage "https://github.com/pemistahl/grex"
  url "https://github.com/pemistahl/grex/archive/v1.3.0.tar.gz"
  sha256 "a330ce004fcfdd8958d057a5ae07a85b6546de585fe7d9060d05f0ada7f7686b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bf37cff4ea82f9b40b13cb1e2a1807330f4857ee354be5dbd1b9a3e6df7fdc8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf7ac074ef21c118ebaee8c4bbf71aa467eb8a45432a9909ef2616fd4e9bec98"
    sha256 cellar: :any_skip_relocation, monterey:       "83247c922a747faa7b3b0a7e6a86b0e015928f698f23a3af32f6ec6c8f96b1fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b0cbb149ea3361e6f29372f8c476328615c69e389b65b4e7f6288df7c408637"
    sha256 cellar: :any_skip_relocation, catalina:       "1a6cdbda35cbbe7a8d85e08288f7ea16dca180630483aa1aaecd52641c1169ee"
    sha256 cellar: :any_skip_relocation, mojave:         "b5ddd5d77b6e0ee87f82be555d6b528352e643deff829ee8741578a7ce7ddec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6dd7656719c14a22a5078fa331132b735eefb8787fac58ee27f1dd054d20891"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/grex a b c")
    assert_match "^[a-c]$\n", output
  end
end
