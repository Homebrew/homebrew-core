class Grex < Formula
  desc "Command-line tool for generating regular expressions"
  homepage "https://github.com/pemistahl/grex"
  url "https://github.com/pemistahl/grex/archive/v1.4.1.tar.gz"
  sha256 "8413aae520d696969525961438d22e31cd966058ce3510e91e77da18603c96b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de4fa3ab2dcccdf2ce89b0b26b6ad7c411ca52768193374e09c5a9be498b7c01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93faa205dcca15ad00a4a2ccbe024e14b7c9e88132bd3dde0556ebe918b235b6"
    sha256 cellar: :any_skip_relocation, monterey:       "3fe2becef0cb4f6696080ed09016d86315308acc0e948dd7cfa9bf0aae2fcbde"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9b1d18003ad754a1791960dacd2ace005c50b10ab583b635cf8f74eb0385c1f"
    sha256 cellar: :any_skip_relocation, catalina:       "3956929a4fdb956eca7ae44648183cb458b01b24fc765c70c551fc13a8dce9b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4009880a091af2ae1148a6d4234100e082d106a4b9644c8c5eb9ce171fd39b0"
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
