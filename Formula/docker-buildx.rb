class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx.git",
      tag:      "v0.10.5",
      revision: "86bdced7766639d56baa4c7c449a4f6468490f87"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1387dc8f75840dc4c09281ba0799331fe063dc1b99e217c6ce67be98e54b6a3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1387dc8f75840dc4c09281ba0799331fe063dc1b99e217c6ce67be98e54b6a3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1387dc8f75840dc4c09281ba0799331fe063dc1b99e217c6ce67be98e54b6a3c"
    sha256 cellar: :any_skip_relocation, ventura:        "dc89ad3fe7e49fa7979e29aac128ffa693a8a735b585ed5e4a4c8ae0a24514c5"
    sha256 cellar: :any_skip_relocation, monterey:       "dc89ad3fe7e49fa7979e29aac128ffa693a8a735b585ed5e4a4c8ae0a24514c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc89ad3fe7e49fa7979e29aac128ffa693a8a735b585ed5e4a4c8ae0a24514c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b579c292bd780f481604ca59771f705d44e5b0ba9701eb9be6920f3b52a6505e"
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
