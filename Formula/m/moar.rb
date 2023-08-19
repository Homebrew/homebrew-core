class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.15.3.tar.gz"
  sha256 "9cbfd11cc128052c66dde381d77b2c4bfb1260feb1e0a0d23119844b274fe659"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da788e88c609f20550140faebd8accf8aee1b72379637c62e44c030dfdad3090"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da788e88c609f20550140faebd8accf8aee1b72379637c62e44c030dfdad3090"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da788e88c609f20550140faebd8accf8aee1b72379637c62e44c030dfdad3090"
    sha256 cellar: :any_skip_relocation, ventura:        "497d2e7fc772727f3ae20fe359149b4f3e789b29ef303d8bf7be3b8706c5b5ec"
    sha256 cellar: :any_skip_relocation, monterey:       "497d2e7fc772727f3ae20fe359149b4f3e789b29ef303d8bf7be3b8706c5b5ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "497d2e7fc772727f3ae20fe359149b4f3e789b29ef303d8bf7be3b8706c5b5ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "426d91653bbf5d7a1a66c22d8ee068832aa159d1cddea528a261faa875c6e00c"
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
