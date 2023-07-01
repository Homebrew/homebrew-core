class Erdtree < Formula
  desc "Multi-threaded file-tree visualizer and disk usage analyzer"
  homepage "https://github.com/solidiquis/erdtree"
  url "https://github.com/solidiquis/erdtree/archive/refs/tags/v3.1.tar.gz"
  sha256 "57ac2a7bb5ba51d1e451c3f42659ecd134ac6c164c65673b84be160640cc9497"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16feadb04e4caafa8cebb926309e6c9ace2c48b82014c67a00feed58410d95a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19a8dc75e2e4ccbeaded787b6d511dc17c2cbcdb71fdc32a4f69401afa27dfb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3cd45623439450d6852218a230e9af81850a9422ea156b09dab8de7afbc77d21"
    sha256 cellar: :any_skip_relocation, ventura:        "49ee681f02872339a5409d92826a76090ebe623cdba3bfdf2cba509f27204e50"
    sha256 cellar: :any_skip_relocation, monterey:       "aa396ac24f954bc3458c3c67f0d82eafbe5761d3a85459443cbc2c99d52ca475"
    sha256 cellar: :any_skip_relocation, big_sur:        "5365d68f1405200f27c976050fec52615b7cf1f13aa472b1dc2c37fc15f1680a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "807a8f67954f89adc41ba3877395d6ade1ab5e6643fa64885073cf8ddece1a07"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"erd", "--completions")
  end

  test do
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}/erd")
  end
end
