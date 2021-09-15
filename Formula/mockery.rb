class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.9.2.tar.gz"
  sha256 "a7de4dad9e89922b0e38f86f0a7f8f2bfc4c2c4be41fa3e66178c46964464476"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bc6ff67317ca508ecab4b667a4e251b820053e577b0ded85a632858fc741f708"
    sha256 cellar: :any_skip_relocation, big_sur:       "5c7b0db7b050594b36773f5e0dc6f79b5e76a117c88552d052970bdfcbf47795"
    sha256 cellar: :any_skip_relocation, catalina:      "7aea00ec374077aa816a63c399b331ca86c2484c53bb908de95ece061248ed1e"
    sha256 cellar: :any_skip_relocation, mojave:        "9edcb992d0e840ca6037ec906a6ba3b4c665a0b2301560cf8cedb5002998512a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d11a0fa5691bbd95718c5b9ffcc15c08dccd7d37efe4b7a5a606ba06b8157c9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vektra/mockery/v2/pkg/config.SemVer=#{version}")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=#{version}", output
  end
end
