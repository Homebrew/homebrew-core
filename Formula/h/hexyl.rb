class Hexyl < Formula
  desc "Command-line hex viewer"
  homepage "https://github.com/sharkdp/hexyl"
  url "https://github.com/sharkdp/hexyl/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "5205fa1a483c66997f5a7179cdd1a277ebb5e0a743bb269a962d20b29dd735f8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/hexyl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47840f2ffb16fcb2d4a78556a79c00e2cd18d5cbe723c358eaa92b1edf5e7a72"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb8d7ef2f04405b08e996f6a44d5fe934bf762da6406fadef831be353fc7eac9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa4f47a4a455618ec36efd674ce9f34139161d19d013ecf62de726af8fa7cfd1"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e639fa05686f3707032fe01755a2e9a1ef17b3ece0574681f784112981e834d"
    sha256 cellar: :any_skip_relocation, ventura:        "ffa62bb30bf6d67ca78143753ed9ef5f52dae96bee8f86f331f704ee3c89b153"
    sha256 cellar: :any_skip_relocation, monterey:       "7b42c01944d81f20cc9e880aecdecd2231f8449907c87fbead6364746a35a6f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9017bafc48b6087ec8b236e3f62906d75ac882d6a5207058e50016048047a6d"
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
