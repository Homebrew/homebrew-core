class HarborCli < Formula
  desc "CLI for Harbor container registry"
  homepage "https://github.com/goharbor/harbor-cli"
  url "https://github.com/goharbor/harbor-cli/archive/refs/tags/v0.0.15.tar.gz"
  sha256 "f7323306672e4b1cf88152e6293e95faa42a410d8cbf1bec7b2adb0d27994101"
  license "Apache-2.0"
  head "https://github.com/goharbor/harbor-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cb769351d63965dce36dd9cffa9bf979e854327ffc1c791e7326a025d72ca3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cb769351d63965dce36dd9cffa9bf979e854327ffc1c791e7326a025d72ca3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cb769351d63965dce36dd9cffa9bf979e854327ffc1c791e7326a025d72ca3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f17b25573f1c9f371eacac5b0304d616e7cd24e7e97678c178ff195d501ceb0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d71619dcca7d493e1b86e4d48d55064ef706fe68deace2ab1da9e31595ec31c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bac9abb0a28d26e58e2e8c440c7d1af9c49021eb8b929db4aad51b2981bbb99"
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
