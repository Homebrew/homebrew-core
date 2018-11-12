class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.9.0.tar.gz"
  sha256 "4ce9c118cf5da1159a882dea389f3c5737b5d98192e9a619b0fe8c1730341cc6"

  bottle do
    sha256 "feb7b5af916d972b796c19cae512445b55072b22d6306df646b2c073b37ed081" => :mojave
    sha256 "35447bd7311bdb54056cbd470dd9449b88ccecc4c62f45d237d51445f1a2a88e" => :high_sierra
    sha256 "c7ccfa8aeda9b8d2a4e2f8dd6cdc6af2667c0bf036708a7c676fe915e9929ef5" => :sierra
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
