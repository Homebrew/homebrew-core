class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.19.8.tar.gz"
  sha256 "0f18f8a2a93b9188b64495c780458f6c34725432b59c56b478d31313b8420827"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  bottle do
    manifest_sha256 "ba00e3d326fb5689c41ce64af3f799cc20c2d0c50154171b92208bb72c384fc9"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c7e516beb07335816dcc7b039c3d703dcc0ef3911bc0452dce3fe44f82aff05b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c7e516beb07335816dcc7b039c3d703dcc0ef3911bc0452dce3fe44f82aff05b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c7e516beb07335816dcc7b039c3d703dcc0ef3911bc0452dce3fe44f82aff05b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "39ff42456eba014e83d77e402dd3761be06c424f8eacf3e0c1907474a33d7a8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f8de0d2084576f9d82992e9352e496dcc568524147316f6ceea821473f43c676"
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
