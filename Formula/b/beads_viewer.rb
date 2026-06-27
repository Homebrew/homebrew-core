class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "67fe4faeb1ea7b366d80b49f28cf2541429bd6e29bd4a7023630fa309a70414a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e37ed6c5bdb8df491aa840ca449526052329a431d08dbd3be1c3ef0ffb8052a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e37ed6c5bdb8df491aa840ca449526052329a431d08dbd3be1c3ef0ffb8052a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e37ed6c5bdb8df491aa840ca449526052329a431d08dbd3be1c3ef0ffb8052a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d265bd40ea9d50ef82334cfe11c287be7ed854c32e4bc12ee85d44a906004b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7517b0477f0a76672484e16ac3c689ff93f76c8845ee5c0f8c2a52615e978fe"
    sha256 cellar: :any,                 x86_64_linux:  "628e8c31182d31e78544edcb6e4fd8c7d1598b25c833253e1624e08307275b31"
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
