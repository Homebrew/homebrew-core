class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.22.0.tar.gz"
  sha256 "409bc8a4bf50ab4402accb8e499ad62d2c548cff551e76594588ec34264b667e"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4922e98c4f400f75190229d4f52cb2a871d8cd7b8c0f579755f163358c96d88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c96844a366b51f1852912c16f96c664e1e50bd36c1ace5a5edc1b359f63c2553"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c52912200c323c35800806086387490f53b11047bf4ae800d2988a2a47799b2e"
    sha256 cellar: :any_skip_relocation, ventura:        "db06d6322436b62186bc379f2dc89d59b2c7cff165140d6fa2743ce211018ece"
    sha256 cellar: :any_skip_relocation, monterey:       "0dafdd60927d98b0cb11271dd7cf1eb3e0454620f96bc963ba401265e10b6a30"
    sha256 cellar: :any_skip_relocation, big_sur:        "6442c880a8e6f05185900df985e626bfe285fd8a3a2fc69969fcf7701f7d7dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6401c042606505d01b3ddbce104a8968fc26b23f6e75630baccec0354156fe3f"
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
