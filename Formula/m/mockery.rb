class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.46.2.tar.gz"
  sha256 "740407dd46872216dc3a7e55bff188d982a533b2f0f8a00c75fbc0eea2645343"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff52d2f1e842e2bb23bc103760fba6d68035bb1542cb76932b25a8a498c609cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff52d2f1e842e2bb23bc103760fba6d68035bb1542cb76932b25a8a498c609cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff52d2f1e842e2bb23bc103760fba6d68035bb1542cb76932b25a8a498c609cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "14ad01dd50dfb06a7ebbd02090226fd647756ce54d9e292138a2922d707ffde1"
    sha256 cellar: :any_skip_relocation, ventura:       "14ad01dd50dfb06a7ebbd02090226fd647756ce54d9e292138a2922d707ffde1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c88e2a6742c389d46e4f4fdee6c8147156ab299cb87456e37903dce11efc887"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
