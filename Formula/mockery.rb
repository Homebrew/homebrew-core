class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.30.1.tar.gz"
  sha256 "0fd52f0770c40e523e1a786e2aa4b2dc820bb069fd37e88a2a1520fdc7e269cf"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6591e36bdfcba8dca09e01a9e24e94f727c286032fd8cbbae989343d6f904141"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12e202e6da4a74411cb432f5cce5b839ba75761815c31299461def813905c873"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dcedec80ba9557b22fd817f4f82c73ebf68a20c69e9601622791d2c92404eb29"
    sha256 cellar: :any_skip_relocation, ventura:        "def0c6fca25c7b7d71705980eb67ca05c0b5b9a5a2030d25ad7752afe5019a28"
    sha256 cellar: :any_skip_relocation, monterey:       "f3aaea71fe671b809152904ba8683687bedaf7a84de9b7b9053d161c1078bdd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "0dd8efd6ddb2e9ea149aa57a96581779c168a20de61b1635e5da33f14d8ae09f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f1a3ccd765eb2de7244bcb6fe0e85b93b7c76cb7d3b27b4237ed06e5e4087b2"
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
