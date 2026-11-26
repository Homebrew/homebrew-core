class HarborCli < Formula
  desc "CLI for Harbor container registry"
  homepage "https://github.com/goharbor/harbor-cli"
  url "https://github.com/goharbor/harbor-cli/archive/refs/tags/v0.0.28.tar.gz"
  sha256 "36362223c987d47c440fcda8e50a928c8ebe0ff1992c09422aeec4ae99aacc67"
  license "Apache-2.0"
  head "https://github.com/goharbor/harbor-cli.git", branch: "main"

  bottle do
    manifest_sha256 "f28ae7469974ef786c602120e3e10ff58dc7dec4068a0092c6fbffeff5c330f5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6c8cfa23947cdbf5c7664757a315eb614ce7d0f5f19c337551f9e044c79ae5be"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9b871a18834b3cb41f8ee4698c0c0a09a773bf4ffdb2d95f91a9a23035b1aa07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "94b21200f1546995042b0da0e5da3a83bd4876e6610df18f19559e251a424aeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "13922d23d429e58871c1b7983e364135915a90ca7131f0f8700d6291fc4fe04e"
    sha256 cellar: :any,                 x86_64_linux:      "bb8bf0ed47c3377e9a3ff85f8dce411ad8a42f4c5b6cb8c14a055e4e9570c6d5"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.Version=#{version}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.GoVersion=#{Formula["go"].version}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.GitCommit=#{tap.user}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"harbor"), "./cmd/harbor"

    generate_completions_from_executable(bin/"harbor", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/harbor version")

    output = shell_output("#{bin}/harbor repo list 2>&1", 1)
    assert_match "Error: failed to get project name", output
  end
end
