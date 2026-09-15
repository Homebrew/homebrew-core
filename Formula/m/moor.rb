class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.19.1.tar.gz"
  sha256 "35e2f1bda3079b02f72d4c0b09a72f2687054d647d7502a0821b0ef8ee1ae417"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5302106a45c53c3e93da63ce3559f6ba4d3e6a6324c2f80a74f1a8ed2bded467"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5302106a45c53c3e93da63ce3559f6ba4d3e6a6324c2f80a74f1a8ed2bded467"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5302106a45c53c3e93da63ce3559f6ba4d3e6a6324c2f80a74f1a8ed2bded467"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4cede0c073b60fb23d173dd0e90da920aa9c39b42caabb18c1331a78c0f43445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9a52eb679f80184e697120782a5ac066c9e6b82f5312612c56295050467dff59"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
