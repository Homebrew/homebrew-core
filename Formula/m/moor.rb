class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "389a1454ce7deedc43d9a17bce48d044ff6a71ac8ef497ea3e347f3f6bfe3d63"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ee57b58904de4638268c962fe90f2a677bf640c740f083d4d092d828ecfb1ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ee57b58904de4638268c962fe90f2a677bf640c740f083d4d092d828ecfb1ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ee57b58904de4638268c962fe90f2a677bf640c740f083d4d092d828ecfb1ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2a1b85bbce2a36d3821238f22320ae60d6c9348558fda889fafa946728bb4bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd231c3d7d2ee2f49b3957a6cbe72568e348c0fc39ff3eaf5a1199920b06f6e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d4a75952f19ea29fc63a46ab1477267230871f28d63f52910c4d6bbfa7a73ee"
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
