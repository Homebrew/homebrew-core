class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.10.1.tar.gz"
  sha256 "badcbf9b4701cf18be66a4a243eb9b9a442c98035fd0ae1e35f06eac4a448e89"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e320c8e29f2776131e62354b8ddabe980f2751c51081cd8834c6715fe8825529"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c52f5e705990c9217fc0901708300f1f3f3b4911e74bab645b79e16b30c157c7"
    sha256 cellar: :any_skip_relocation, monterey:       "057a0fe6cd9e1b16fa518c2b5e5d440bced0ff3e4ade79099d1b4216f6ccc122"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd2ba93b917573b75a1b572d1b771b290b4b88cc7cddf8639c0b524cad1c9a4f"
    sha256 cellar: :any_skip_relocation, catalina:       "9ba9be4482c5bf960760ba26778fcfa294da90e0937e70027e540777620712af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2218f44e889eebcc8967e410b5bac3de40b1c4a4b2362b852a013e071aefed20"
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
