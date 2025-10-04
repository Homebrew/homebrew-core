class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "20f62461257d3f20ac98c6e6d3f22ca676710644d9e4688c2e4c082bfba9b619"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "282781e5d5f4b8152ea8996ebabe22b750ff7eaa6ab1d8f2e7f849ecfe1a2f38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "282781e5d5f4b8152ea8996ebabe22b750ff7eaa6ab1d8f2e7f849ecfe1a2f38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "282781e5d5f4b8152ea8996ebabe22b750ff7eaa6ab1d8f2e7f849ecfe1a2f38"
    sha256 cellar: :any_skip_relocation, sonoma:        "549cd90392f7a784fc3f55e2df744cf03814d3f618e61f3d9fb03cc5f92e8fac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "649cfa5586cec3c2bba7d67e277f26e7747c9dcddb677eb80f2f40ec7c4f9a3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9142ccfa5d29b2641467b59c6a23db9afddfe6a530251dd5a508c9f65be681d7"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X github.com/docker/buildx/version.Version=v#{version}
      -X github.com/docker/buildx/version.Revision=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/buildx"

    (lib/"docker/cli-plugins").install_symlink bin/"docker-buildx"
    doc.install buildpath.glob("docs/reference/*.md")

    generate_completions_from_executable(bin/"docker-buildx", "completion")
  end

  def caveats
    <<~EOS
      docker-buildx is a Docker plugin. For Docker to find the plugin, add "cliPluginsExtraDirs" to ~/.docker/config.json:
        "cliPluginsExtraDirs": [
            "#{HOMEBREW_PREFIX}/lib/docker/cli-plugins"
        ]
    EOS
  end

  test do
    assert_match "github.com/docker/buildx v#{version}", shell_output("#{bin}/docker-buildx version")
    output = shell_output("#{bin}/docker-buildx build . 2>&1", 1)
    assert_match(/(denied while trying to|Cannot) connect to the Docker daemon/, output)
  end
end
