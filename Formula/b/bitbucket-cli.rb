class BitbucketCli < Formula
  desc "CLI for Bitbucket Cloud and Data Center"
  homepage "https://github.com/avivsinai/bitbucket-cli"
  url "https://github.com/avivsinai/bitbucket-cli/archive/refs/tags/v0.40.2.tar.gz"
  sha256 "2a46bd417ea5362c0a118f083147beaad4a6e05e4fa6101e94997f47a27b20c5"
  license "MIT"
  head "https://github.com/avivsinai/bitbucket-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "15eac371cdbb64eef34bbe8a525bb06bc1ada66274cd5dfd9ed73b92d67c8be7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1f903ea503be28c7e13fc31711deba6f09354314b4c495e18c72520071072eae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e2f7a16ca94eda7b25520244cae171a44d0251acb34e397d33be781935d743a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c482a031e7160a3fe1f4d012966222d8b71c2315e7debf139b8b0f1dd3b87f77"
    sha256 cellar: :any,                 x86_64_linux:      "c2c0e166302d1e63139ad0deba08be964a94b42c0e1595bf513dd082e0016ef6"
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
