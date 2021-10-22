class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v3.0.0.tar.gz"
  sha256 "fc39c793c34dd1766af2df1dde98626dd2f0145facb5e53ffdfb8cdbc116bcdf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "efe6f2d0e6bf319e6efe5dd8481bea0d49815c8d9fffcdcfcc17effbf0296340"
    sha256 cellar: :any_skip_relocation, big_sur:       "770a5b40da517bfe64aced5a6e99d00da85a41c7b0f037acf68ccc1f48909991"
    sha256 cellar: :any_skip_relocation, catalina:      "b50b3d84ef4f97884d55501480e088e6fb0ab39c06b2d79cf0cffd24b7be79e3"
    sha256 cellar: :any_skip_relocation, mojave:        "fdc6e35e06cb648a60035ac47087657155f2845ade5f90be894bfe2a31cd0327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5da2d8b465a3baee4b76317f083184724db09be018c99012ad708ca72210236"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
