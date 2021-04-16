class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.7.4.tar.gz"
  sha256 "22297f811490d4eac93f26b129ed3b58a9d5b42893496a32acce0b4756676870"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "52b5d054b7f4dc2e94d65e4b0cf9da43c12babc8bdaae0cfa69db666eb7f6ec4"
    sha256 cellar: :any_skip_relocation, big_sur:       "d10aaaa636ca0d1d3f1196ff645aca0c78eb8d8908556bddb786df9b233f7a24"
    sha256 cellar: :any_skip_relocation, catalina:      "e3ba46770f9b31a0dcbcdacd60f6d55317c0e554d57729787b72b08f1a254828"
    sha256 cellar: :any_skip_relocation, mojave:        "c6021ba38358d6dfaec61d4a4c6ebd5729ea78f95ef41c52a5903083e87d6b05"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X github.com/vektra/mockery/v2/pkg/config.SemVer=#{version}"
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=#{version}", output
  end
end
