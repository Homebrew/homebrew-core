class Ptui < Formula
  desc "PTUI"
  homepage "https://github.com/narbs/ptui"
  url "https://github.com/narbs/ptui/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "0f77cec856b9e06a4b749a2b86b78794ae4595b6b2e27b02aa127fd90fa8bf82"
  license "MIT"

  depends_on "rust" => :build
  depends_on "chafa"
  depends_on "imagemagick"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ptui --version")
  end
end
