class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "478eb7bc7af01c5c99f0105e20e2dfe998f2f8f6b5c5e1db21da0ff472be0356"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a95d4c7a7dec1dee2b4498b010ab88d99f2716dd0bae34465949fe881640b014"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a95d4c7a7dec1dee2b4498b010ab88d99f2716dd0bae34465949fe881640b014"
    sha256 cellar: :any_skip_relocation, monterey:       "74f314b711c0329751ecfb7f1ec12df8fad429f5373039819732ab3b751eb8ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "74f314b711c0329751ecfb7f1ec12df8fad429f5373039819732ab3b751eb8ee"
    sha256 cellar: :any_skip_relocation, catalina:       "74f314b711c0329751ecfb7f1ec12df8fad429f5373039819732ab3b751eb8ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72825701b567abf527e427b3c0feb177a638b3e50d6a9826d6cf78cdcd8b1ac2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
