class BitbucketCli < Formula
  desc "CLI for Bitbucket Cloud and Data Center"
  homepage "https://github.com/avivsinai/bitbucket-cli"
  url "https://github.com/avivsinai/bitbucket-cli/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "a4faf80f10042f6a48411d8573fdb9e13035b84bfd1bd0b76ca2c79be4bd08df"
  license "MIT"
  head "https://github.com/avivsinai/bitbucket-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6120ecc11d3d2f8a06346d62ced1fe7e63b1489e6a3501cf78813e3b6c2cbe38"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "10db33691a48762d4af10e31aa08618a39266cd6af4003a53aa7d4fb7828d952"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "74eb2bbb5fc29e78e334e743d068da350cd747989799c2da81e93c664332f6ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d2f31271a00fe18e19a7b0e2786206d7d9cdd45504dea1adbd30e58bfd49e646"
    sha256 cellar: :any,                 x86_64_linux:      "5881fd5f90a60fbf89bcb6a3fcafb605a28f9165a9e72e33552b7bf133c84a7b"
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
