class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "86613f304981096fb52e85bee8cf44c9c732da3163fd066be184b81d4b065199"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00363bfe97610515be5613d29d2e06c0d6640d8d3eee31efa2aedc6b4532901e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00363bfe97610515be5613d29d2e06c0d6640d8d3eee31efa2aedc6b4532901e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00363bfe97610515be5613d29d2e06c0d6640d8d3eee31efa2aedc6b4532901e"
    sha256 cellar: :any_skip_relocation, sonoma:        "41bd61e248090d37e786c23990e626b0636ee0b9271f89ce79fbc25915f4bcb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dade48ceeb46d92004cdec3e1e9f992d973e36e48e74af5cc1c9078645b15756"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74d503072bda34dda322e4cdcdf165fede3a7b6a0e2609375701549479f209df"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
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
