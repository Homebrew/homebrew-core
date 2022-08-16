class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx.git",
      tag:      "v0.9.0",
      revision: "611329fc7f1365556789bff4747f608d40cdc8a9"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af81ad4cc48622c450d673284c382a122627d4e60db9f1262c51cdd89335cfbb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2631eee8d80efb6658d6f0c54ec21eb4e8ed5d6a43b1b291bbf2795a50121239"
    sha256 cellar: :any_skip_relocation, monterey:       "5951f6e8b450f0ff95d6a9cad612c585745f68731a0645905b4e78b3df1b6cbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "df31b6beb4c675a03e56aa629b0b9923ca7b73358c598916e1aab9518786c02e"
    sha256 cellar: :any_skip_relocation, catalina:       "7c4c9e152b9feaeeb28b1e58ea9b0f4f39b5ba72a74d4d3f85b7e9c73089cf7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bafa05434f0a5563b1c72c66a4f7a9cee041a321a37dba34d92eeb065d4539f"
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
