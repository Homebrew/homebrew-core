class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.35.2.tar.gz"
  sha256 "12ca713f7797c0eb95df2588ec04097b2af06559e67118e0b043514ec327c327"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1f65e117be676189f06a1d911b4b88c48f621e4c61b3c5832a1a5c64adecf4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a08f2aa454f23bb60871e2013357869ae654fea07e2f66b7db4e61cb415eef0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a82e9f1a86f68b186eb172364fd48eab2d0ebf9f2577e0e311c55574f82ccaa"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d70c06ea2b9d34968ad312aa6c4d9850be79ce170280e7891e0fe695c97b0c3"
    sha256 cellar: :any_skip_relocation, ventura:        "22fc7cb4d90ac1367add46f770903b2502bbd2bdfc0df9079dd941d089cac629"
    sha256 cellar: :any_skip_relocation, monterey:       "4c7a9e78bfde427419bd2d1a0cdfdfa453ca61b780f6c70021d46f77932b3aaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68f57d52acd1c6658fa1980c345202e5f8c8ed694a9831734b0b8ceef84dcb73"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
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
