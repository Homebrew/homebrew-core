class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "ae901ba6bf680c9ce4c0a223b127f30c38cba83c8a8df4aaf79dbb256b03a30e"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d2efa7f99d54c4967ef4f110094dd97d5d7f2c55f5f24f4c2ce4ffdfbfc3b85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d2efa7f99d54c4967ef4f110094dd97d5d7f2c55f5f24f4c2ce4ffdfbfc3b85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d2efa7f99d54c4967ef4f110094dd97d5d7f2c55f5f24f4c2ce4ffdfbfc3b85"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c7f558cc9fe85888b2dd41661f9e5d3de358873befe4d208a39ee3182c8b3a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7516147aa10413a9b3bc936cc94d9d2de38fa34ece5fbcbbf630b26643ba45f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f42412804ed47ecfc82a085d2bf5e1667713789adcf5e7a1e3091d9abb8c47b0"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

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
