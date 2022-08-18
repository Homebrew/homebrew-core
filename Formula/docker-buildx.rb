class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx.git",
      tag:      "v0.9.1",
      revision: "ed00243a0ce2a0aee75311b06e32d33b44729689"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97ae712c58b12213799c3f6c59f36338ee0353501e8244695f5186be4442fd16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7af3150098bfafb7ecadc9ca0fd21ba12b889449243a654e8cc232ad13cc8108"
    sha256 cellar: :any_skip_relocation, monterey:       "b3dd7450b328327ce2e8fc5517b2f3a5394607083bde7a7e61d7692218fb909d"
    sha256 cellar: :any_skip_relocation, big_sur:        "666695043d6d942e7e72c167002a44eea8e49d6125ded2655f27f62111780484"
    sha256 cellar: :any_skip_relocation, catalina:       "428ac69ed210b9a453c6f6a7e2b32f5c9c6511dbc8e81bad46c1267dfcd7c713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1626ce4d37481d6d921d0ab13dd8584ac382cb21b69630e3cea05b4d191da6a7"
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
