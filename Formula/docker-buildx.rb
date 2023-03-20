class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx.git",
      tag:      "v0.10.4",
      revision: "c513d34049e499c53468deac6c4267ee72948f02"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c7fc21c164fb63befb7409757b963f9d372330e8a70a6c1a5fb9c9e62b7b48e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c7fc21c164fb63befb7409757b963f9d372330e8a70a6c1a5fb9c9e62b7b48e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c7fc21c164fb63befb7409757b963f9d372330e8a70a6c1a5fb9c9e62b7b48e"
    sha256 cellar: :any_skip_relocation, ventura:        "6ce242d47304f101712141540efc4f3cb4314132918466bdab5d5b4de84c885f"
    sha256 cellar: :any_skip_relocation, monterey:       "6ce242d47304f101712141540efc4f3cb4314132918466bdab5d5b4de84c885f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ce242d47304f101712141540efc4f3cb4314132918466bdab5d5b4de84c885f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "304acee37c3e38c0819a91a6a884b41955df511e7e74304cd02660e8ed42711c"
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
