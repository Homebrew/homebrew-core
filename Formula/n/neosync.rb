class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "39070c1fa23023abcd451a2292c11c1dd63ab3f0f11cbf0b3e69437ba5e474b4"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3fde83f6d3c94059f43c8eedc1e9db26063db45cc160a33bae520a0b62e0478"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3fde83f6d3c94059f43c8eedc1e9db26063db45cc160a33bae520a0b62e0478"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3fde83f6d3c94059f43c8eedc1e9db26063db45cc160a33bae520a0b62e0478"
    sha256 cellar: :any_skip_relocation, sonoma:        "f26ce0ea858b88a7a4703ec135cef8c500f35fc514921ba4d88162bdfb5e2bee"
    sha256 cellar: :any_skip_relocation, ventura:       "f26ce0ea858b88a7a4703ec135cef8c500f35fc514921ba4d88162bdfb5e2bee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e75192582af90f15164ec005856d5be34d4ae375327fe315c3a80d9d236fefe2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cli/cmd/neosync"

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
