class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.32",
      revision: "0576dbdbcda4c071cd9ffbd30640d23f344e449f"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61f8defbf92f3e24263e6f6edcacaecc78ce529b1eec25e0ebafae18317af0dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61f8defbf92f3e24263e6f6edcacaecc78ce529b1eec25e0ebafae18317af0dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61f8defbf92f3e24263e6f6edcacaecc78ce529b1eec25e0ebafae18317af0dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bbd6fede2d037bcbd61b99ec49d666f5056c77f271f4889a0197d1779d76adf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b853047d8afb3fc59d926bc943be807fe06cf9faa673a8613ccafb2140904c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b559fe9ea27983ef6781b8975fe746a6b56d44d7fe0fcbd1501b3247890ca79b"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "production")

    bin.install_symlink "flyctl" => "fly"

    %w[flyctl fly].each do |cmd|
      generate_completions_from_executable(bin/cmd, shell_parameter_format: :cobra)
    end
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: no access token available. Please login with 'flyctl auth login'\n", flyctl_status

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Create a new Fly.io app", pipe_output("#{bin}/flyctl mcp server", json, 0)
  end
end
