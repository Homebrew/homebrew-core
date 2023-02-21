class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.20.2.tar.gz"
  sha256 "2dde91bc8465111b61d934d695749413c9596e7b6bc64351af1e5c5e776d7d54"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ee2ad233f27d1347666898375263730b76435577e7e90b645437b5e74531e92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d912b39b1ebeb1ccb9d1906b9dd134ffed2d615f3d8a61a9ce6730e03e27ca88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "011cedb95fd90ad56d82c512b05ec63a646d4b08272d6b3f72d4d18a620d7a6c"
    sha256 cellar: :any_skip_relocation, ventura:        "95622936be6c5c8320cd0320576e7a124f7c13c0944dd6e437a6a7aa77568298"
    sha256 cellar: :any_skip_relocation, monterey:       "5c97524fa4be691d77dffcb39413eb639364190b5194eb9cf05c3c3346eb137f"
    sha256 cellar: :any_skip_relocation, big_sur:        "72e9450ac6e92c23929e5df76e5b9e56b05f4a8c982b1731a3fa773a3c5c3c07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07afebab0629c04dd3cac0a03755d186764451d370aa4e0ba091b93a47e0a942"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vektra/mockery/v2/pkg/config.SemVer=v#{version}")

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=v#{version}", output
  end
end
