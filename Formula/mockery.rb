class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.12.2.tar.gz"
  sha256 "f5962e4506dd749b9bcc2785c1e5ac683bddac5ba0219382677365d558d2080c"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d34b198b93ff51e90b4f0d94879a84f805cba4c0c6ef5aeeda5627dd35bf866"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f7792a9b01f3172e313d67e09ce12ef63e9a3624d457246f839791dcd48cefa"
    sha256 cellar: :any_skip_relocation, monterey:       "6d4c126ec4f057384c1f110db9e4829ec0211a4b3f89628a898bd396b62750ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "aac59ffd8c933897b1c86db3e930cc3c4a8c4af478aee132abdc22e5ccbfc575"
    sha256 cellar: :any_skip_relocation, catalina:       "0f312a81858b0144d47de7416aa24cfcc572ff6938fb2ed9ed9af3f6a620a05c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efa7e6c47602cc82ec08eedb908dc21fd5ef2901a1dcd62e112ddce8dcd019a6"
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
