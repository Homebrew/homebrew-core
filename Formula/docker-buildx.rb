class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx.git",
      tag:      "v0.9.1",
      revision: "ed00243a0ce2a0aee75311b06e32d33b44729689"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "678aaeb1c9cba605d9b004de0903e9ddd450d2e2b124c14e9aee614c14abafa4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30e60e92b6d3d72c137d9cd62676a9ad3847ffeefbada5fb204dcd6934af0255"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3631233cbfcca28a2ffe46b2eaa9aa818d493a6d1df016bf2a97a7a7806cfb0f"
    sha256 cellar: :any_skip_relocation, ventura:        "a400fd184c165801495e2e37bc0a6c262cc71d92aea4706e643ece283f515a91"
    sha256 cellar: :any_skip_relocation, monterey:       "04bb00b8fa1d06fffeef91d7684e723c280c6ee579af653aaf8ebf4df3d13b71"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b2c1ee80eeb656f394d4e545fd7390b3ecad9eff1d22413e704d852b5864d89"
    sha256 cellar: :any_skip_relocation, catalina:       "9eb3d096a740abd0ba45d38e46063a56e49cced1f52e549a78d4ffa6a71e7765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b055b152f0b64228325b9a9300684bb07a8cc0a92ebad574a2754a9bf5b5557e"
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
