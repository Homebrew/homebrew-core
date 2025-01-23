class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.51.1.tar.gz"
  sha256 "639d51db980531a69b846e9ea9c010e5763fdd7be4813b292a84b06938baceef"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf7ca7c663f6a8c7a93d16d2dc0cc0c25e06125ba18256c5cbe4eb4d73221977"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf7ca7c663f6a8c7a93d16d2dc0cc0c25e06125ba18256c5cbe4eb4d73221977"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf7ca7c663f6a8c7a93d16d2dc0cc0c25e06125ba18256c5cbe4eb4d73221977"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffade2fb4e47548f63953d6ebabd3e607c8984e48eb8a91fa8fe0ff4fa035fbb"
    sha256 cellar: :any_skip_relocation, ventura:       "ffade2fb4e47548f63953d6ebabd3e607c8984e48eb8a91fa8fe0ff4fa035fbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c466995713676cb5f434ae11bc77290944a1cd59c115a117ebb12523e4fdefea"
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
