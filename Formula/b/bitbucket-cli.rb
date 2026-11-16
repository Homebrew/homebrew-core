class BitbucketCli < Formula
  desc "CLI for Bitbucket Cloud and Data Center"
  homepage "https://github.com/avivsinai/bitbucket-cli"
  url "https://github.com/avivsinai/bitbucket-cli/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "858321b0bcd261d6fc40e0ddbcbfa351680cb8e02a241f0b0787b26c547ac18e"
  license "MIT"
  head "https://github.com/avivsinai/bitbucket-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c860da78b9a568eaa6d165dda1da2eeca2ca90a7956a1bb0134bf7c7e238fab9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a2231d69804fbbf2d305d883646eb74f8e0314aefd6b624b6608812ca8bfc90b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1c85e377d3a07f2d10c578a974b02073b906b3e0ae6396abb61711d46b042b2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "aebcf07089f109f61d6067b3449fe865cbef625e22d9f30c3b12a12ec300faf5"
    sha256 cellar: :any,                 x86_64_linux:      "87bc933a33d377c85a076d310efa87dfabe71dd809ed12e30a90fa188cf1fd0e"
  end

  depends_on "go" => :build

  conflicts_with "bkt", because: "both install `bkt` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/avivsinai/bitbucket-cli/internal/build.versionFromLdflags=#{version}
      -X github.com/avivsinai/bitbucket-cli/internal/build.dateFromLdflags=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"bkt"), "./cmd/bkt"
    generate_completions_from_executable(bin/"bkt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkt --version")
    assert_match "No contexts configured", shell_output("#{bin}/bkt context list")
    assert_match "no active context", shell_output("#{bin}/bkt repo list 2>&1", 1)
  end
end
