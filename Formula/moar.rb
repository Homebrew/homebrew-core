class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "27e14f8320b24a3e88aee40ca741fdff7a63a6b7a8c5d8042270f472fa5ee332"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc865768ab090a321c1dda2abd277538d1ae16daf387530e47d4e10bb97c7cc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc865768ab090a321c1dda2abd277538d1ae16daf387530e47d4e10bb97c7cc9"
    sha256 cellar: :any_skip_relocation, monterey:       "3b8f4b7b5c2aa317509f434605a6a8a7296147a5dd11c73a6809db519f5a46ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b8f4b7b5c2aa317509f434605a6a8a7296147a5dd11c73a6809db519f5a46ba"
    sha256 cellar: :any_skip_relocation, catalina:       "3b8f4b7b5c2aa317509f434605a6a8a7296147a5dd11c73a6809db519f5a46ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b1fe6ba2e005b08033e0005d68d7245c998ef2ec5a69c28611898419e40b5a8"
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
