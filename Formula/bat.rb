class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.6.0.tar.gz"
  sha256 "3e182844c861cad5e214e504a81930bccf3c3916ee6821a73e932540b1c2de46"

  bottle do
    sha256 "89de36476128da34336df03f720ae7d55923762d16f50bba7dc83c7dedeb028d" => :mojave
    sha256 "3760824d4272735df6d98f82c54948822de9c411b01868a5625d3db76c2311bf" => :high_sierra
    sha256 "a792b99e8537a6c75da573f6b7588c966f1bef9420fc1ce7e228752cedf80582" => :sierra
    sha256 "5c9c4c4e39d3c876990e5e8b6d6d9c0176ec3f89dacfb92d0c39bde3a2b1f524" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
