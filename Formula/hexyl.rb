class Hexyl < Formula
  desc "Command-line hex viewer"
  homepage "https://github.com/sharkdp/hexyl"
  url "https://github.com/sharkdp/hexyl/archive/v0.12.0.tar.gz"
  sha256 "bf3a3e8851e7bbcf01f75ae95c018faf3c9f1b7f363159d4a7459bbe11478144"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/hexyl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f033d8bb6aa0df9c5bf32552ab2f023a0b0067b892d1e5d5d8207ec838730dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f73c44d29f4953e97fb48939b36f551189197d08c7b99c3dcb91f04be63ce0ea"
    sha256 cellar: :any_skip_relocation, ventura:        "35386ebfeb38d54bec134e92e8229432e7e8ddcc34c8dd2c8a98a67087a34833"
    sha256 cellar: :any_skip_relocation, monterey:       "3ab6dd0e35b54784bbedfb46099f52edb3a258cc0cf1dac1e9074137e58ada81"
    sha256 cellar: :any_skip_relocation, big_sur:        "97e15dc5c3e71eb3598a56870fde2d3e547306b6780a51ad1c0ca93672c1a28b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85ced5662e57be08b28ca529df677e6d1cbe74c491e9450eb8e5b9194724a2c5"
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
