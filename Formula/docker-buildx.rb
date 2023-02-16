class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx.git",
      tag:      "v0.10.3",
      revision: "79e156beb11f697f06ac67fa1fb958e4762c0fab"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce18c5f8433cd14ac4bbb6a95210d8b769d8e8d06e2a48b1e71970fa9af29aba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c4bb47231aff1b84b3483e3509764785761c594c9bdce358816795433f4ac61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "149008312f8b21d8d1b6bdc5665d5fea74c628afbb9375b4b845b798f99b6c45"
    sha256 cellar: :any_skip_relocation, ventura:        "46bd805abcdd690490627c0ace0049fcc4a0fe09d7897089ed065e924263a13d"
    sha256 cellar: :any_skip_relocation, monterey:       "40ce3e72f5759dbe16a607a3e5ce13b7323c7ae3aff0d7ed7bdfc4d5a285bb0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "49587309de93dcd3394293c5fb9cfceaf71712f0da8f95b217d06491a4e6bd3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fa2f03af8783f2b214ecefe4af9d23be2581637f7fa954f276a25306924bc72"
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
