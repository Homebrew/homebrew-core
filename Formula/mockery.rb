class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.19.0.tar.gz"
  sha256 "36bf38c136de8dddba36e4de2c7675cfd511c0702e772a0fd27a99fa191448e7"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "541c7bba18ca4653bf995ae97d4f26c4d37ba5738b23337e0113adb608f62e8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3da6d5f012d5729ad1dbf972e109ea4a5e25d7ab6928603dabdf701be3ea18b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41a4cf288db44ff9c90440e40bb7af036aa0281e59ffa240b1bc18fc9c18c642"
    sha256 cellar: :any_skip_relocation, ventura:        "c370849aa1709de4f83c7d5a3dfe20500ad524be895a52e62758c6ce6ae70db9"
    sha256 cellar: :any_skip_relocation, monterey:       "7ff151bd8dcb5b8123287ed542993491e415d0bf61bda639e3dcedc8a6b59973"
    sha256 cellar: :any_skip_relocation, big_sur:        "50d097da8ff2ec87e8ed97c495b544a512bb12eaefadf84915a1c5ed5f1b97b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a197fcfbe05d167e2a3f6fb72488524bccaa22bfbde6134eee2dfce81bbe8d22"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vektra/mockery/v2/pkg/config.SemVer=v#{version}")

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=v#{version}", output
  end
end
