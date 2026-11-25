class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.58.2.tar.gz"
  sha256 "4c0880a2aecbec12ad161b6b98164348d9a9587520309e53151f7369bffae492"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "df9586440be7c77b328498ccbde1a92ad2b7b423d74193e9f78ba9002617a582"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "26e119cd9b773a849e0a892d901208525ace76ffb552a0efb6256e74d76a7242"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "afea522699cf0237daaa9e97ef93e1c730f1bfc1f95b6885cdfc46bee919bf75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a6a2ddf00d5208b3cd752a557d0ed3a18945f8e74fcc7030ba2df14079fce80"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "53d1c60a3fefd0618ce13cd9f7e5d6a96f0f367b13205aba58b4bfd14ac65315"
    sha256 cellar: :any,                 x86_64_linux:      "2bca55c7b8fc98c8f637b81fd2961bccb1367e67f0934b6d3aaa3abfb7c7fda0"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
