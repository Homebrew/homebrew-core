class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.19.7.tar.gz"
  sha256 "940547b19cd7307b93572739fbc9b71dcb196a191f05fb941e472295d9389f3a"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "09d521c0b4b22d5b2dbc99e4e342b4fb3f39ef9d96403a61c70c0de62c9273da"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "09d521c0b4b22d5b2dbc99e4e342b4fb3f39ef9d96403a61c70c0de62c9273da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "09d521c0b4b22d5b2dbc99e4e342b4fb3f39ef9d96403a61c70c0de62c9273da"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "de65fb498ce95eef61f52721b5eb4f219a02740b15bcf27e60e7ec7387774179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a1c8d698db00856fe056148e4f7d53dad7726bcf32563d785bdc36c4dfffef97"
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
