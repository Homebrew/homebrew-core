class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "0a21d90888f5c932a9ccb6711dcd163e4e301a1bcfc97c00e4c7d7f0418a01f7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc0b3b175a5e5771e9dd74ffc7d949febe8525cf472e63fd56945489e9b315ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc0b3b175a5e5771e9dd74ffc7d949febe8525cf472e63fd56945489e9b315ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc0b3b175a5e5771e9dd74ffc7d949febe8525cf472e63fd56945489e9b315ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "50a3902f29d8c663c02802f09bb933bd8a8458fa522b40d11ab1d953c9fa3701"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cba9367387eb80fcf05859c0da9fdcee2e0b3ba4d028d2e8f47e3c5c20a8c1bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "972d338c1f041a5154f173ebc811e0d704e801b5017fcebcf2bbc1e33568ce10"
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
