class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.44.2.tar.gz"
  sha256 "e70f78578a02d9caaf444739d65f074b8fc4e9967e43028b7d3e063e66604d11"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd42cd639645044b3081e9a38ee667e5decf5fce4f43ad93886947a899d2fcf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21e7c087b618b0f10d37ea28ade0e863a381d63d0514a61b9152d794be3f5480"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "564f8a9ad62d44194bfe37352a5bc4d4a7b5019fd18295cd723b4ec12f944ac1"
    sha256 cellar: :any_skip_relocation, sonoma:         "495c8018252fd7558a13243071ff46a1be6146168a261f1014e5fb9647e25548"
    sha256 cellar: :any_skip_relocation, ventura:        "7000ee662edd5b4d4e0bee0402de409accbb9041d39407bc30385fc09806408c"
    sha256 cellar: :any_skip_relocation, monterey:       "3280fcf6b83f83be94b799ab9515a7f354a9abdbf7361c253394066fdc31cb92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a99c0ea817e5bbe1d2988df2f3494eceac2d27c4c7c925c0c17110a1d5387e62"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
