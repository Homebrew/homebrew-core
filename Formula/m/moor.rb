class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "defac420180c46e814be9cb0819b4a8467a78adf0c34d9341909a5867755230e"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54499a16d7c553a45a24911a3dd0d74f0b58e808cf77729f859a8f6b195996d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54499a16d7c553a45a24911a3dd0d74f0b58e808cf77729f859a8f6b195996d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54499a16d7c553a45a24911a3dd0d74f0b58e808cf77729f859a8f6b195996d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "06b5638a70c1d3130754d62dbe5d22f535994e9fd3d8d1093bfb4432a11e0ce0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec24bbf282b6e208c96f9f3072e23b83652a913b38383c167f921e73184e93e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e74be9cbdb8494692e05627cce8c0164b88d27b097e1180875c0ac7d867e7542"
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
