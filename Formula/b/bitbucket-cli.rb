class BitbucketCli < Formula
  desc "CLI for Bitbucket Cloud and Data Center"
  homepage "https://github.com/avivsinai/bitbucket-cli"
  url "https://github.com/avivsinai/bitbucket-cli/archive/refs/tags/v0.41.1.tar.gz"
  sha256 "4e080843a60d11685b0856984f8ffb8f1095b3a17bba5c7a5d3fd232d7d76017"
  license "MIT"
  head "https://github.com/avivsinai/bitbucket-cli.git", branch: "master"

  bottle do
    manifest_sha256 "f0cc41bf032a512dcfe26a4346f0f940acceb3b3bcda17264101404250d26856"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ae387a2781a6c42999527c4482a879ad0e256842ac7e7a7b9c4e96e221a81058"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2516c217935e21431bc15cfb0f3e1567f00b25991f32ef99a8d903bc4f559090"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d97fbaad58c6e10a328f3e6ea50b2c168f7b3ffdcc960fa25d35bf744c6ec73b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "470e933ae745df722bbbfb6e824cc92c7737d817679b1f7a3a251572d087160c"
    sha256 cellar: :any,                 x86_64_linux:      "284189c714067878cee6283c733c2f6bc452cd73d4dd07b526520ca82959f2e1"
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
