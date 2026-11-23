class BitbucketCli < Formula
  desc "CLI for Bitbucket Cloud and Data Center"
  homepage "https://github.com/avivsinai/bitbucket-cli"
  url "https://github.com/avivsinai/bitbucket-cli/archive/refs/tags/v0.40.4.tar.gz"
  sha256 "83474922358b5be896e0f535c69ae515d466fe04ce8bd912e06dc9ba8efe8375"
  license "MIT"
  head "https://github.com/avivsinai/bitbucket-cli.git", branch: "master"

  bottle do
    manifest_sha256 "b347f2a90c487c298dd5635ecbc83d1dd738de6f053912d89536aa8821011f75"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b4574f0bdbac6b4828737e7b9f7de2d71bfd6f5c0df6b697c87379b024c9a9ed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d26569efe3374dcd962b7f082430ef62bdc8722fd6c8191f3c98deda6ec37e0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a319314b2bd9ff6ee8d0aee928de647a19361bff33224099a4ec9cfad477e21b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "37ca61293f625ec25c645474f0fe6a8e9c0d517dfde4840611cb2d77d7a816e7"
    sha256 cellar: :any,                 x86_64_linux:      "1a084b93be54ea49bafd7b77732723b511a0969fa9c3ee5ed7244d6a98b49985"
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
