class Grex < Formula
  desc "Command-line tool for generating regular expressions"
  homepage "https://github.com/pemistahl/grex"
  url "https://github.com/pemistahl/grex/archive/v1.4.1.tar.gz"
  sha256 "8413aae520d696969525961438d22e31cd966058ce3510e91e77da18603c96b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4d764c88b4782cbef31147648255308e126c9472a2ada49df3f3de951fd6c47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d33f897da2827403bc9ef112a4ee875329d2360d1a3cfb4ac965eb702834f606"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3b81bfa0d82e9c04f0b00c81e4fd4f48ca3673896296a012fda75d5c6d87953"
    sha256 cellar: :any_skip_relocation, ventura:        "a2c13b3f72faeba89ce1a2089184dbfce140b8ac77b68409cff4247bd29c238d"
    sha256 cellar: :any_skip_relocation, monterey:       "e6424ebfd8737e658a9812c8aba0cb19238dd2068eaebeb726d6d67f80d93513"
    sha256 cellar: :any_skip_relocation, big_sur:        "af44a111757bd4663e052060b960f7046854629aac5f8889aad824a14cbb78cd"
    sha256 cellar: :any_skip_relocation, catalina:       "729a50cd4cba23602eae010095e01dcd70a21e6e525e9a108b940415722a571d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e380e5cf8f6cba9cb0fa7739b26351bee0e3bd89a9007c095ae2396e258df204"
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
