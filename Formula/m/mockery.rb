class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.33.2.tar.gz"
  sha256 "ab38c4e313f0a5866e13ddd94afcb7dbd5060a60bc0c0745fac6482b5a8dd226"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9c3d0e1fd9bc4923f562a36215bd71a6db35d7f0bfba6a7b9acb96529ccd08f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6303b7aa9062d20600efdca3e2cba89340c1d5e3f480d86376dd83c08051120"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60283e430b463741d9cd71d90dcb9c08d4f738fb078b622de1ee7a964a15d30b"
    sha256 cellar: :any_skip_relocation, ventura:        "a0f5aafda7e80c4d7daa56eda01a6265f00788776b9b52b3035e32fac720b4b5"
    sha256 cellar: :any_skip_relocation, monterey:       "e10cf17f7c83437e07581a518649abf7f6a9de20bc2e9e56174a6d52e1d00cc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "86f0f5fcfbf74590aff646b70bce264946632a9e6edb8d0bb32ca449b370f677"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "407d60d1e5cf8c23d32b3c706624a13818e545b5e51240207465b5e4aac7008c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
