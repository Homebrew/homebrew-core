class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx.git",
      tag:      "v0.9.1",
      revision: "ed00243a0ce2a0aee75311b06e32d33b44729689"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b58d89d30266fd8fab49b7ec815f6b801f37bdac3ebb713c38826ecef60e1f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce33790cb2c3e83f4245819458dac41179195eb72e0de9b54541cffb287af319"
    sha256 cellar: :any_skip_relocation, monterey:       "fbf4f9b019e888e2a6a6d906b454fedc8646e35f11be927076d4aae9d45b254c"
    sha256 cellar: :any_skip_relocation, big_sur:        "26b21d1e1843b8da03baa342bb99430b3f7a1a3e0b14f6b760cab0c3ac482bf4"
    sha256 cellar: :any_skip_relocation, catalina:       "52744a454ca31e9b34f44b724d4095b59e612498ba5e68f83f7483654505dcf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc6c1716bd652aaaf069d4def30640a75e64aad3e3f8006e2ee6d028f0e0a08d"
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
