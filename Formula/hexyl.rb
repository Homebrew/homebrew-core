class Hexyl < Formula
  desc "Command-line hex viewer"
  homepage "https://github.com/sharkdp/hexyl"
  url "https://github.com/sharkdp/hexyl/archive/v0.3.1.tar.gz"
  sha256 "c0dec617cf2723dda349d365de6c3e916ce61e56eb2695b72bcead2df90953cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c43d2d80a90c12a02f19865f2557f52075363f629019b02107b2b568b284824" => :mojave
    sha256 "2063e6061c019ad0ff3d63941f77d6ceb3dde296e429afa6dc52b518d2629b26" => :high_sierra
    sha256 "fc7908fc3e4641fbf494b103abbcac6014a9c8a0b00fc7097719d06acc28f066" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/hexyl -n 100 #{pdf}")
    assert_match "00000000", output
  end
end
