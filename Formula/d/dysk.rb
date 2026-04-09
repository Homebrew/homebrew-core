class Dysk < Formula
  desc "Linux utility to get information on filesystems, like df but better"
  homepage "https://dystroy.org/dysk/"
  url "https://github.com/Canop/dysk/archive/refs/tags/v3.6.0b.tar.gz"
  sha256 "59125412523853348218ff57eb1f58f31158e88dc172949d1007b4adbc7a4e61"
  license "MIT"
  head "https://github.com/Canop/dysk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22e9f515113fb818883c5023d022fdb56803f68566c994bebe084bb54d5752c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91fac06f26f5bf802e027f17686b90c21bbdeeeb8614606667fb2f855078cc5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a02043bf7301466a8620243d8ab87dc876f2220da74fd353185a7a44f5b2bcbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a67b8e9d077a9c901a4c01647437c4d98bbf0e7d76478c689832cb41777d63f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b39cb0b4f3622c660a99e1b1d0ee07932019a6c1f159cb04a06b0bd775d1be9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85e6ac0e35f6bf433039d96489fdb439b0eee416d72b1f74947b6fcd0c57ce64"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "filesystem", shell_output("#{bin}/dysk -s free-d")
    assert_match version.to_s, shell_output("#{bin}/dysk --version")
  end
end
