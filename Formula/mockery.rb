class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.21.3.tar.gz"
  sha256 "875061a9b9661bc81e3a5bfe45e22211efa2e000f08639e6d74314ac4ba1cd78"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58688fd2631aa99901c7244e14f3c9d256f75996932dd4dc494c73c15c8b0898"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aeacfab3d8b26ae743a58fae20f98fd3671e0c632058c7b98d7fd36cf4bd9b6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38bdd6de9b9742b1df471106786b3c4a61198d5d3fe000ceb80c3dc6e1a3fd25"
    sha256 cellar: :any_skip_relocation, ventura:        "78855ab2f22366e0d7607cb4b0fc7becf43e0c7e772dc259a72cc3174e699e02"
    sha256 cellar: :any_skip_relocation, monterey:       "474ca9a4a18fb4a2bf1f56c92552680c1f7b198ce94a02f5bc9ca87b36f46d25"
    sha256 cellar: :any_skip_relocation, big_sur:        "e92cb9616e6699d93c58eed1da4951b1f3ad5d0f3724e62be55bd56d1ee195ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23dc6410ff5d33de073e0b28d0c7594a0a073105f80bec37f4052f7eb4db8534"
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
