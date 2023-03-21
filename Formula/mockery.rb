class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.23.1.tar.gz"
  sha256 "9172cbc0f722047175fc030b61adef9a74ec2d35ca1fc1d9cbc53fb0b4faf27d"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77495c81535bc83e84f30953443048ba9df0d9fdde7e9ac0f6c3f23c1644c255"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "411241a06c895a3b7096caf150c95d39ffb88dc99e06ac2fdc71847983ea784b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa70f33328ce6d5399704bff82afb410bcc588c1211fdd472608e5633d5a1f43"
    sha256 cellar: :any_skip_relocation, ventura:        "0264a44bb209055d55b87e06a103bb4ef7edad17009cd199b131131042773e3d"
    sha256 cellar: :any_skip_relocation, monterey:       "e90b902bf24abd71df235b44f2f0a1f2ec92e9e30b9988d4ca36f2112a9e7f57"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfc655f1340939aa3a65dec6da04a631a8289f17973dc52ea2ece10f1611ad12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c74c92bdf4142817415d6c13ed12acc353d6367fd74906f261038503da633602"
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
