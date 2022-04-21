class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.12.0.tar.gz"
  sha256 "6d230aa3778cbf7b88e4d4765819a988d5f7eb45ecf2f4f53ed6b04f0de2615b"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ab8b976ad97517f1813b7c7716fb58dc29fc718b48e9d4f91a86add51bd7632"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5608b93675d7bcab8dca540822cd32d07547994b43293272cd438864990e85be"
    sha256 cellar: :any_skip_relocation, monterey:       "96c486090f8ac603be2b394da30c645c84daed8ecf3abf6b3f1e1785be37b84f"
    sha256 cellar: :any_skip_relocation, big_sur:        "065cf0e124facc07bc969674ff082dca444a015faea86abfd439233c51722848"
    sha256 cellar: :any_skip_relocation, catalina:       "fda0bd5c599b283bb8641849f7ec767380d8638ce94c20effc1ce3fb16ea02e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7fa4000fc6be280699afd8f3a59a2595cb4077654d9e84d9df59febcb9b55e7"
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
