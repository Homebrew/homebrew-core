class HarborCli < Formula
  desc "CLI for Harbor container registry"
  homepage "https://github.com/goharbor/harbor-cli"
  url "https://github.com/goharbor/harbor-cli/archive/refs/tags/v0.0.15.tar.gz"
  sha256 "f7323306672e4b1cf88152e6293e95faa42a410d8cbf1bec7b2adb0d27994101"
  license "Apache-2.0"
  head "https://github.com/goharbor/harbor-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e78a24b1c8308b67e46f19a9df083a6253e4a33d13df18e35d3a23bdf79043eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e78a24b1c8308b67e46f19a9df083a6253e4a33d13df18e35d3a23bdf79043eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e78a24b1c8308b67e46f19a9df083a6253e4a33d13df18e35d3a23bdf79043eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5da3257ca34c7b9035ae893aac44ce75a1abb8ac92f4255e71cb8dd7b8c35af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54f5ae8e66d99a8f9c43412d709b3d159e885a509e3fb3b40216c4b0c7462ac8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c2af0b68ae68bbee178472b06c2b9bda57655c0df2dccd4c7ef90cf075bda54"
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

    generate_completions_from_executable(bin/"harbor", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/harbor version")

    output = shell_output("#{bin}/harbor repo list 2>&1", 1)
    assert_match "Error: failed to get project name", output
  end
end
