class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.8.0.tar.gz"
  sha256 "577664399cf24695f51b702350c1a3fe460cd296a6a12ed0938bb937a4b3b00d"

  bottle do
    sha256 "f7c03e20e2e2174dbfbd459bbc9e682566ca2c2d95981e6e7a0bb16f6029376c" => :mojave
    sha256 "7eae56919890dbde0df25e05cc9c8ebc5fb7200538c16fb1499d55f6c9486063" => :high_sierra
    sha256 "646d4b06070a71bfa915703cfb9f57df7eafb674316decf8688dc2152f10bb70" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
    man1.install "doc/bat.1"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
