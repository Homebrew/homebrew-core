class BitbucketCli < Formula
  desc "CLI for Bitbucket Cloud and Data Center"
  homepage "https://github.com/avivsinai/bitbucket-cli"
  url "https://github.com/avivsinai/bitbucket-cli/archive/refs/tags/v0.35.2.tar.gz"
  sha256 "d1de981e9f29704baf8f2db551f206055ffdcefac1ee36239625c8ffab4ef21f"
  license "MIT"
  head "https://github.com/avivsinai/bitbucket-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d0d562a1743e7020e3e87685419a1d9ca5dd90d21d05de27015c48dcad097fba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e61a32fc76868425129366b627d4cf3944e314f54297c476a0c431908d445f0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9ad55a8b762186a0cd428e1c5afc4f2fecc741633deda94570d03758c6c278a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a7b01c2a0a92047a431af589089b050d92fed4ff4c876662fc7a59f93bb13bde"
    sha256 cellar: :any,                 x86_64_linux:      "5343babdf66cc23120abbffd9d7f4606c5c67ddfcdfc0eca3ee91efdd3bda27e"
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
