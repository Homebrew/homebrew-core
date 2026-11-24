class BitbucketCli < Formula
  desc "CLI for Bitbucket Cloud and Data Center"
  homepage "https://github.com/avivsinai/bitbucket-cli"
  url "https://github.com/avivsinai/bitbucket-cli/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "896ea45ef42bd72e92fb105cf59036bb87a2193c0bc7ffceb018749a5f3d8ad4"
  license "MIT"
  head "https://github.com/avivsinai/bitbucket-cli.git", branch: "master"

  bottle do
    manifest_sha256 "9a9fb97226d6f78d73da38b9923f1821d6957ef1c5988bb3eee6b61ed050b48b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4e9aca42b097885ea7cb0f84daf7b8b4b71f6b100ca80046a9d83f77acba1106"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e2ed84e7ec4b6cd8eb1b8aef8eb959e3f7f0f0a6047c51425424a06f3a2824be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "54a1bcbcc8813611fb0883c46c0c148da05f7a01b8515431e4f0b37e1fcb7377"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0f4c08b5687dbe8a24c7b4492f48dd6ac81a744701bdbbc7d5114bbc030deeaf"
    sha256 cellar: :any,                 x86_64_linux:      "ecf3e7a3a0aaf0ba37517dcc2c4e0a7f26c04392b1edeb051cd3906b896854f8"
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
