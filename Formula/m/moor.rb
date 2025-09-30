class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "5bbd0faa5059bc84f8d29f363029897bb973e6625efc32c570d4aa421b769daa"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17007f75ca1e0a91f4453aebc0a69147d601684d919f0262c56ee6e7c92e20ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17007f75ca1e0a91f4453aebc0a69147d601684d919f0262c56ee6e7c92e20ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17007f75ca1e0a91f4453aebc0a69147d601684d919f0262c56ee6e7c92e20ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "32465f31d810f8e2d7af8f2ce53ef9bd85d632ffc49331b6f0f89bd7a25b3229"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "288ae9bef0b87a61327ba342d3c7ff226d25a31c749fb3a9280445bd2c1d4134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "454c9f7ca299b3ea400fdf7a2fa3b9cd49d596a4cc07ee1410531600ae7a8a7b"
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
