class HarborCli < Formula
  desc "CLI for Harbor container registry"
  homepage "https://github.com/goharbor/harbor-cli"
  url "https://github.com/goharbor/harbor-cli/archive/refs/tags/v0.0.17.tar.gz"
  sha256 "6b8f183569a85f64399e6fcf7b34058894bf177067a34243088c44b1e6fd67a4"
  license "Apache-2.0"
  head "https://github.com/goharbor/harbor-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e44e38ad6d3b8e36ecafed353bb6263b29e3abe02ec1902d5129c8970b5e1b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e44e38ad6d3b8e36ecafed353bb6263b29e3abe02ec1902d5129c8970b5e1b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e44e38ad6d3b8e36ecafed353bb6263b29e3abe02ec1902d5129c8970b5e1b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "fca1a579b52d8b73265c2ab61e6cc729fb84c812d97347cb21cb86668d24adc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7bfa1fa4a449d8891c392d12d8c6d463f9652f7437cfc0a20c39bb726d3efa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59c9cb16af6aee8c8e8f769b03c986bb43135633300c4449aeb6d35fd4e48933"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
