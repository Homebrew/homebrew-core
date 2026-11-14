class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.19.7.tar.gz"
  sha256 "940547b19cd7307b93572739fbc9b71dcb196a191f05fb941e472295d9389f3a"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3e49863af56645075d42102e02287971b23c3b63618e5479ae18ba5719efffde"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3e49863af56645075d42102e02287971b23c3b63618e5479ae18ba5719efffde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3e49863af56645075d42102e02287971b23c3b63618e5479ae18ba5719efffde"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2274d85d998e7afa1942ba969343440961192e8f020b7cf06c6951a3afe832d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9bf493ca9905e2385cc7c5cfebec83014d20914a231a6d046eb1ad188fa5a88a"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/moor"

    # Hint for moar users to start typing "moor" instead
    bin.install "scripts/moar"

    man1.install "moor.1"
  end

  test do
    # Test piping text through moor
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moor test.txt").strip
  end
end
