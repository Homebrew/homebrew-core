class Erdtree < Formula
  desc "Multi-threaded file-tree visualizer and disk usage analyzer"
  homepage "https://github.com/solidiquis/erdtree"
  url "https://github.com/solidiquis/erdtree/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "5e18506734f67d6800ffc65238209a5e5db8080c53ca2f91dc5646376183ef8c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d170b23d58a67abfec80c9c5f29ba01fe1b2659656a955f7b579ee4b4f7c0f59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a1c1270bdeda3430db564a76339fdcb277c88c6efa9668c05585beaf5a86f6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7d370f7cc6a65c6cb9878cf8cf285526fdbddf868acff1ea7e8732f56c84d94"
    sha256 cellar: :any_skip_relocation, ventura:        "2bcc3b14a12af3415a883c7a04e367a6fa6922d2e3c25f103f021d3276aa1a12"
    sha256 cellar: :any_skip_relocation, monterey:       "16540e70ba5d4b1fb2f09a5e407062053f7450599e3b2cd824eb2d1df240c1fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b78a56f5462a60933b4054b5d2cc083121419158f08e6656eb50d13e4719d25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07c30f096a56ddab09af2ccbb39ed1db52de3a99483b3595e2def8856cfaf086"
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
