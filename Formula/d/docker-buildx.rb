class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx.git",
      tag:      "v0.11.2",
      revision: "9872040b6626fb7d87ef7296fd5b832e8cc2ad17"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9725a277a0819ee7377757e94b83d30b14d69314756110aec9638ad6d13e858"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9725a277a0819ee7377757e94b83d30b14d69314756110aec9638ad6d13e858"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9725a277a0819ee7377757e94b83d30b14d69314756110aec9638ad6d13e858"
    sha256 cellar: :any_skip_relocation, ventura:        "058c89a3d99ac1468dc4c4c597d046fc45d0841676d4580daec5b2e4595f8917"
    sha256 cellar: :any_skip_relocation, monterey:       "058c89a3d99ac1468dc4c4c597d046fc45d0841676d4580daec5b2e4595f8917"
    sha256 cellar: :any_skip_relocation, big_sur:        "058c89a3d99ac1468dc4c4c597d046fc45d0841676d4580daec5b2e4595f8917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d751b318df3339bda76840e644c926d73bb0f96141f1b3817997701cf26e669"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/buildx/version.Version=v#{version}
      -X github.com/docker/buildx/version.Revision=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/buildx"

    doc.install Dir["docs/reference/*.md"]

    generate_completions_from_executable(bin/"docker-buildx", "completion")
  end

  def caveats
    <<~EOS
      docker-buildx is a Docker plugin. For Docker to find this plugin, symlink it:
        mkdir -p ~/.docker/cli-plugins
        ln -sfn #{opt_bin}/docker-buildx ~/.docker/cli-plugins/docker-buildx
    EOS
  end

  test do
    assert_match "github.com/docker/buildx v#{version}", shell_output("#{bin}/docker-buildx version")
    output = shell_output(bin/"docker-buildx build . 2>&1", 1)
    assert_match(/(denied while trying to|Cannot) connect to the Docker daemon/, output)
  end
end
