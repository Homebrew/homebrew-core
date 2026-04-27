class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.12.2.tar.gz"
  sha256 "5ee0e14c80651bc12f2e6c8ede41d632aca46043e46171f328c24a208213e802"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb5b556fa4a11ec0cfae4ca522dfb31538006c82f80e547b0878cf58841e7e47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb5b556fa4a11ec0cfae4ca522dfb31538006c82f80e547b0878cf58841e7e47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb5b556fa4a11ec0cfae4ca522dfb31538006c82f80e547b0878cf58841e7e47"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d720a00194e8b8d5815c83372fe139cd6dd241e7eba64c9284fb97104c035dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6c0849b3dc3991b43a88160da199ad48572211aefbf23d0b16d20d915b644d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a1a556eb25c447b881eeca06a4595e7a67b686336859b2ee9b7a6a811945738"
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
