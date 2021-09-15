class Grex < Formula
  desc "Command-line tool for generating regular expressions"
  homepage "https://github.com/pemistahl/grex"
  url "https://github.com/pemistahl/grex/archive/v1.2.0.tar.gz"
  sha256 "24b27ee194232d9280f86ed11ee1863e6636eea4423013bfe78b2ebc21002404"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "63e6b42f1291ed20745ec03172d1f74381000428ad121106395245ae56e8a9f8"
    sha256 cellar: :any_skip_relocation, big_sur:       "71e83e6dbadecdb52c697a2456fdaf034b9c44e2cc7cb8046dcc4805373e1ea9"
    sha256 cellar: :any_skip_relocation, catalina:      "40d88d50787a5bec63fb9cce19fd6fd53d10ad044991ba267a2417a108e2d854"
    sha256 cellar: :any_skip_relocation, mojave:        "a9f695cb21282080aa381736a03c152765031c78f773cc5dd8afd38c7b5e78e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1e31edc4a15403b5575f03be1669af9a301af903b446e67ca1da84cd4c10cd4"
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
