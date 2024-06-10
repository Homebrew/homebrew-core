class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.25.tar.gz"
  sha256 "b1b3e067e9c40dc01f16d9342a05a0bb03f130779fa15d14975767988e1d165f"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e965b7883f5bc934781768b3c5bafd9c26310d7eee3df1ae1a1ca7f2f8ded85"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a776df47abb7d3a99f08bb9f5a86f6d69f856cc5294cb3170e0d8f4bc5a9d40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaf9acb011c015c07a1b8a82e5561bf8569a7d99923ca749503499d67c9db2b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "332146719b5ebbfb963fcc0acae1cbcb1a47bd68e84ed2b759c59fe6c6ecda5c"
    sha256 cellar: :any_skip_relocation, ventura:        "91cab4651c6ee653ad04c944a2f92ba37bf41c0114a958135789c6e0e33db2d8"
    sha256 cellar: :any_skip_relocation, monterey:       "1ee5e14302a7ffd692ba6e25e5153e97e383b334d5510037dcbeecd2589352af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d12f47b7d2994a39bc1535067b09f34dc44551e2fdb7b6e13c1b0a894be403dd"
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
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
