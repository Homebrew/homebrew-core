class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.19.5.tar.gz"
  sha256 "1ac816a00e30d601da064176cca6537cb3102132111e247abf24573eff8d4030"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "691d22b6bf06c0b9249514b7cf1a51dce3296fd896f3660be93d8d622a9111f2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "691d22b6bf06c0b9249514b7cf1a51dce3296fd896f3660be93d8d622a9111f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "691d22b6bf06c0b9249514b7cf1a51dce3296fd896f3660be93d8d622a9111f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6ee833e955d6eb153e4289d169e725e41f30a967c4a5e84472d8d955379b5f77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e1ec5c71b41f5b8f52b5511551ebc264558156957bd7efc48c62d4e3ecf374f7"
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
