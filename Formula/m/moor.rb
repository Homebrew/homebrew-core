class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.9.3.tar.gz"
  sha256 "26f106997ba24a898a76f2495f89238aa091c4ad31db2eff0012704e42022d4f"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0fc7d2b4209d061cc6a12108539aa184a6f48c8fb80105b98d41f3dd141d1cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0fc7d2b4209d061cc6a12108539aa184a6f48c8fb80105b98d41f3dd141d1cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0fc7d2b4209d061cc6a12108539aa184a6f48c8fb80105b98d41f3dd141d1cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca96468e33f9fb7a7422b1cde91df692d88dfffe328475114d82d4fceb9e721b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4902261d1b7f71969a5778aa88387f2ff97474f6dbdd2bf4d2337ba12bff205"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed509892dd4556ecce95b07b1f699acec434be7f237e6c28ffd7c64d75e3ca76"
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
