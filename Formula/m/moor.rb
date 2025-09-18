class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "15cd249dca023cf446c379d3a168a0dcb12d4089fe5902558508049b8103ed8b"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fee7b6f49927199d07e320f9ac98d90999af1d78c9e94928b8cf7d17940e90b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fee7b6f49927199d07e320f9ac98d90999af1d78c9e94928b8cf7d17940e90b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fee7b6f49927199d07e320f9ac98d90999af1d78c9e94928b8cf7d17940e90b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9fee7b6f49927199d07e320f9ac98d90999af1d78c9e94928b8cf7d17940e90b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f46f27232a2a947b25ab47d1bfc42759f24d7bd1e99b38c8834bc79a4b1a98ad"
    sha256 cellar: :any_skip_relocation, ventura:       "f46f27232a2a947b25ab47d1bfc42759f24d7bd1e99b38c8834bc79a4b1a98ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6482de7b880179bae1d085d228dd5b449b8d209feb678de57b09abdf8f7a850c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa51b3639e43379695f8f18006db24ce355e5e334446156e9158e61067bce6ee"
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
