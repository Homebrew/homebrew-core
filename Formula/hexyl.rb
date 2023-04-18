class Hexyl < Formula
  desc "Command-line hex viewer"
  homepage "https://github.com/sharkdp/hexyl"
  url "https://github.com/sharkdp/hexyl/archive/v0.12.0.tar.gz"
  sha256 "bf3a3e8851e7bbcf01f75ae95c018faf3c9f1b7f363159d4a7459bbe11478144"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/hexyl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6edbbd88a4a47f038757214438c81aad75dde639d7082c5a66bb76928b2f0c43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bc5cffa1706a75b4d0b6c7af65c89407f875f92d8f44994c6b70b36e4bb3160"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba4180de5a5e9e107e21f07295342d465ed7a7a4612ada48c06d4a38d447b55a"
    sha256 cellar: :any_skip_relocation, ventura:        "2dad61e73eb77225469344d0833d797e29303ad098913df720f21137660b1457"
    sha256 cellar: :any_skip_relocation, monterey:       "09bb90fc13b3f4cbf45bc84272aa19c2bb35d0b526bb726994edc1997575b343"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd78b492b9c38580e3fabcd3ce56ac405751b6cddbedc08a599b30a59bda4de1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4644fc35b963b754ab228dd220305ca4c509238c828956ba1ac6959a0b1c2b0a"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    system "pandoc", "-s", "-f", "markdown", "-t", "man",
                     "doc/hexyl.1.md", "-o", "hexyl.1"
    man1.install "hexyl.1"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/hexyl -n 100 #{pdf}")
    assert_match "00000000", output
  end
end
