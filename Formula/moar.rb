class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "45374ead069d9aa797b329a633241e3de07625242d951be49dbdd959c6c60153"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "816b7f87337233b158238049f8c97a1b04490013cbe772a8c19de80162dc98c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "816b7f87337233b158238049f8c97a1b04490013cbe772a8c19de80162dc98c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "816b7f87337233b158238049f8c97a1b04490013cbe772a8c19de80162dc98c3"
    sha256 cellar: :any_skip_relocation, ventura:        "5adc9d174161a411b062554c1e0de046f2f70c37fd5426316729849cb8f82d0f"
    sha256 cellar: :any_skip_relocation, monterey:       "5adc9d174161a411b062554c1e0de046f2f70c37fd5426316729849cb8f82d0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5adc9d174161a411b062554c1e0de046f2f70c37fd5426316729849cb8f82d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78dd80b0e82d2c372f86729017e4312175d970cd86803b70f40c844587b9c571"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
