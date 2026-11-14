class BitbucketCli < Formula
  desc "CLI for Bitbucket Cloud and Data Center"
  homepage "https://github.com/avivsinai/bitbucket-cli"
  url "https://github.com/avivsinai/bitbucket-cli/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "dbe6edc43dff2196e24988cf3032e0fd94707324c283961acd370d934bb2fc8c"
  license "MIT"
  head "https://github.com/avivsinai/bitbucket-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b43cc34f5e98c33279c3e11e50145ca47989f79adb6aba6a90a6cf321c30ebf3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3aff69b124e2c5b70b708943eff36e59043c64a224e039279d0f9e2ed4bfa5a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9de5a440897d592498f957c7fd28c9ca25cec6dd79f600d95fd8fa80cf379947"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f960ce871341337233b05af53b323f783c013d56de518b74e3fcf761643c4d81"
    sha256 cellar: :any,                 x86_64_linux:      "2bfcef44cb9718643527900e1df099d10f15d21a26edcbf8539e2dd367a26a22"
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
