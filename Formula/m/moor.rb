class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.19.2.tar.gz"
  sha256 "6a46ba770366b9d4993f1221ca5135f6668f88d64ee99c04e1a0c176e1893023"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c1664da17f9f9a86fc3b1e2525b6aab61d4ea44f5e1338c0ccebf525ccc4b61d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c1664da17f9f9a86fc3b1e2525b6aab61d4ea44f5e1338c0ccebf525ccc4b61d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c1664da17f9f9a86fc3b1e2525b6aab61d4ea44f5e1338c0ccebf525ccc4b61d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3ae2dcdd8e6681e45904c411a2a46bb232eaabb9249346deb20d945e447d7f4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "17c77ef3264316576fc8fa973225a60f67bdbd1e62ed8529ce0e32265765628b"
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
