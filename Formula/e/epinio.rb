class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "afe69c38a0f9e2adcfcd55fdbf1688024529a29e4d1ead0827dadaf5ad80c44e"
  license "Apache-2.0"

  # Upstream creates a stable version tag ahead of release but a version isn't
  # considered released until they create the GitHub release.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88c554997feb2a3f2a3032e70fee72d5a9a81cd69459bba77b4f70a4e998991a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da4e3997bafb23f177e4bbc70beb1a8b2dd0ca24eec95b95d0f990034922fade"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0e672419428ec59664490ec4c130446eb4399cbd121bda40eeef60d763f0718"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b8457fc556ac4af30ca2cf4130d38be79c92b31fe607aeee90d8f15d3b466ce"
    sha256 cellar: :any_skip_relocation, ventura:        "c415adb2927b857619415f0d4e79b2e3a60a82da1ab0eae05df8fba008c629cb"
    sha256 cellar: :any_skip_relocation, monterey:       "3827d956cb9617f728ccf0493dba14bad318d467a5195f9e2ae1b98094306a66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4a2521c6aa741beef5c5e6c1d5b1e0e0a990bad6fcb0337ee9e42ee5a49588d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=v#{version}")

    generate_completions_from_executable(bin/"epinio", "completion")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: v#{version}", output

    output = shell_output("#{bin}/epinio settings show 2>&1")
    assert_match "Show Settings", output
  end
end
