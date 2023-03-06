class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.21.1.tar.gz"
  sha256 "a58e4ac8be76f422e4d7a93ed786b32bcd3b817024b81d652493a6eedd9c6bea"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87be9ce2699a4348d62e4458a0d0573b7ce842a4ef41eae61af5d27c45011f04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90ee1f268fd035e8376ea16ac29772d7fc0cf2ca3bef23e28e6189ddc7409a81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de21bac763e7447173fd492c77cba71aa01981d433dd1faa26343cf5a2a87f14"
    sha256 cellar: :any_skip_relocation, ventura:        "0f931c3e11594a11220a5277ecc30d18f4a64cb48d94c7cd703895e74ed36243"
    sha256 cellar: :any_skip_relocation, monterey:       "1a44341792d974ce2f35e11014bc139bb9d9529d1ea2f217ce084d41b90d34ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "b13b8087343e9dcdae33e61090a2ae7b3d5ad88f61cbafa5233ae453ae8e782a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4103cb992011d297691a853640b87d8cbbfbbe4eda1bcc609446859a3f647e4d"
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
