class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "d08bbc7340abb149d9651062ed8c3710bd18c16457fd7597f4cbaedefa2be1b5"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58bea1a01bd8d1fbbf9d7a8f0f7abe88bd88c8dee9cada7037d66353871ff8ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58bea1a01bd8d1fbbf9d7a8f0f7abe88bd88c8dee9cada7037d66353871ff8ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58bea1a01bd8d1fbbf9d7a8f0f7abe88bd88c8dee9cada7037d66353871ff8ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7bc0c1241d9ae166b8ae9f15ee557b049cacf6fc67c8efc1a4ffe379777cec8"
    sha256 cellar: :any_skip_relocation, ventura:        "c7bc0c1241d9ae166b8ae9f15ee557b049cacf6fc67c8efc1a4ffe379777cec8"
    sha256 cellar: :any_skip_relocation, monterey:       "c7bc0c1241d9ae166b8ae9f15ee557b049cacf6fc67c8efc1a4ffe379777cec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e403dbe969177e9dfe971cad95dbb1c6e7cd327d479948fdd0dff2b2f33e43ef"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
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
