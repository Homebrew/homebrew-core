class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "1b433bfd9d9688d143a6612bc44e64a620129be890719d39f5e3e847fd9a3760"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "294cb6464d775709ee6e6b4ed82a867148749c312493be8f0b13ba779dac76da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "294cb6464d775709ee6e6b4ed82a867148749c312493be8f0b13ba779dac76da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "294cb6464d775709ee6e6b4ed82a867148749c312493be8f0b13ba779dac76da"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fd9158c080c9d72d7015b24d2abe0f8df0b04a5e19fd205d75b6393016224ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d652a67fadfc9b9599ec662031ad72144a42cc0ae3145aab6dc6e0078d0cec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f11c0856fb33f7d91195166c73efd6d9377bae17d183531ef813f213377a4a7"
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
