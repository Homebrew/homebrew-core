class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "478eb7bc7af01c5c99f0105e20e2dfe998f2f8f6b5c5e1db21da0ff472be0356"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0a8b47615bfcbabfbc478049384560a8389986a2344263e04d5deb256775179"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0a8b47615bfcbabfbc478049384560a8389986a2344263e04d5deb256775179"
    sha256 cellar: :any_skip_relocation, monterey:       "7151deec429e9911eaeb097d82da0f9a06bcf5634b97a56daf02b2df0bd8b81b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7151deec429e9911eaeb097d82da0f9a06bcf5634b97a56daf02b2df0bd8b81b"
    sha256 cellar: :any_skip_relocation, catalina:       "7151deec429e9911eaeb097d82da0f9a06bcf5634b97a56daf02b2df0bd8b81b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce5054ae3788bb638f1e8a0e256c33160f80a283d12a33601f60ba0a66ed09d5"
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
