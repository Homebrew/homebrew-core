class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.10.2.tar.gz"
  sha256 "f570ad1955348d58d2011d28715f2cf5bbc9308e7f6d5a0410d8f82dd2cf47d4"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15d2ce7d2b1e356a5689f84b8a0422ea46d55d5eeb42567108b7e214f7277662"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8288e20fab12ed588049262b6f7527980bdd03a84e86dd5c6cb1ac528398edf4"
    sha256 cellar: :any_skip_relocation, monterey:       "a9eb11d6cae51a87719dc29eab96e50daea6d7b8a67dd3fc5afe037315f107d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1082b1b6b4671e7fdb313e9f01f65d02e066b29b655039c17b93f9050bdbb00"
    sha256 cellar: :any_skip_relocation, catalina:       "088809a272f0e65f7bfeb75a8b32006700f16f3e79733c27e34192b57a421b6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36a7f5c4f15e1e18e1ff73e223fc2d67e8777a541e74474026317eec3ac18f12"
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
