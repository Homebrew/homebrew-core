class Erdtree < Formula
  desc "Multi-threaded file-tree visualizer and disk usage analyzer"
  homepage "https://github.com/solidiquis/erdtree"
  url "https://github.com/solidiquis/erdtree/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "e44c4d079515c5aa0491486106c04678e67cb2962c43b52b56ee70426709cbe3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8822b33223dd892344fa98c774414f3ff0f940e26f6e888ebec2d5cee3ee2cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4171eebe5bfd31f10969a54fe6353262774639daf16bfea7a1fbf2bccadc2b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21ed73f7ede36ebb986fd93ab390d424b1a5d150d7b15bfccf5242e6f1c4cead"
    sha256 cellar: :any_skip_relocation, ventura:        "7075b075490278db4962c7d28d3dc55394ceb80cb3c8a61761bff3cde838c9fd"
    sha256 cellar: :any_skip_relocation, monterey:       "b416eef53e58ea41d432fd1abcad8cca3ab8ec3f8f40fad410af0b6571bd0d2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "bba29981e53719c8d422a524d360409e045cb3eae6b6f7d8e10cb0236c4c514f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ad912620b61c952ddaf17b757b364d23d1451e6c9bc685f4cc2253677a857bd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}/et")
  end
end
