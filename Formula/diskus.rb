class Diskus < Formula
  desc "Minimal, fast alternative to 'du -sh'"
  homepage "https://github.com/sharkdp/diskus"
  url "https://github.com/sharkdp/diskus/archive/v0.6.0.tar.gz"
  sha256 "661687edefa3218833677660a38ccd4e2a3c45c4a66055c5bfa4667358b97500"

  bottle do
    cellar :any_skip_relocation
    sha256 "09f3ecb398c323353ea7d32d54691504eeacca1b01c494cc232bbf33a2040c0c" => :mojave
    sha256 "ed4bce4e6350c6968696a27faa2271185739a546c1e402d76a8fcae50fbf4ea4" => :high_sierra
    sha256 "b995363af6e1952e299db83d007de1b03d07f288c650aecec04a34b56a83926b" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"test.txt").write("Hello World")
    output = shell_output("#{bin}/diskus #{testpath}/test.txt")
    assert_match /4096/, output
  end
end
