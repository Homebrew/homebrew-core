class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "9d140ab1618ec6d6ac9eefab2856f4924fce7544cba13be5a61001cf4a1dd353"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad4f52a2aa1c532e811f35388614038869d1076b6ee201eee97981b34d045b92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad4f52a2aa1c532e811f35388614038869d1076b6ee201eee97981b34d045b92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad4f52a2aa1c532e811f35388614038869d1076b6ee201eee97981b34d045b92"
    sha256 cellar: :any_skip_relocation, sonoma:        "645ffc3e2de1a0097e16219aecd9436a4409fea58aa0a77061ffac469870ac3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2109cffd9f780227d2b1081d6894b736d43af81dd64a0c6dac6889e197994f04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34ad118a768f6ed23ed68c8c6dcafa65811688659ded9e1a325b654726fa17d7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Dicklesworthstone/beads_viewer/pkg/version.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"bv"), "./cmd/bv"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/bv --version")

    # Test that it detects missing .beads directory.
    output = shell_output("#{bin}/bv --robot-insights 2>&1", 1)
    assert_match "failed to read beads directory", output
  end
end
