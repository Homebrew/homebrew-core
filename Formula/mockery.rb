class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.10.6.tar.gz"
  sha256 "032266aac617102b7b5e16c02be8d889564b18d5f20a006e00e70bd234b7fc91"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bd76fa8790530fa33ebbbd1b561a0e0249f9026bc962a42c066d00450ee83ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "209ccba98c0bbda7289dc230a86205bca79599b4c1345b2ca854419a458d7306"
    sha256 cellar: :any_skip_relocation, monterey:       "b0dcfe04bb4128849c4faa6af892ce7aae065eefda62320a6573165959dcc061"
    sha256 cellar: :any_skip_relocation, big_sur:        "89a84b6cc9df9cb667f1ab3119d377ce70c8b5aa5ca32fdc8440977ea3df74e1"
    sha256 cellar: :any_skip_relocation, catalina:       "94510f3d827babce2173c7579a56932a7ba8429e619d085e3643851a80134dc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71f82d51077667d138df02b6ecb0c9e4bbc4784aafeb23a417b5d8fc1ffd5b12"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vektra/mockery/v2/pkg/config.SemVer=v#{version}")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=v#{version}", output
  end
end
