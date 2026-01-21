class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "d16adbb11be83edfff646d8a980e7bef1768b57120e5af35f37f70f97d0cbaa3"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb8d78a164fb8cec434dedaa082c22c8179bd2d494e97fc67e580f3c9f077ec8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb8d78a164fb8cec434dedaa082c22c8179bd2d494e97fc67e580f3c9f077ec8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb8d78a164fb8cec434dedaa082c22c8179bd2d494e97fc67e580f3c9f077ec8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e8cead5214bea485f7709c6245243b8553a69ec1ac0d1f61ebc688c53437d92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5aa5307f3b8c8304d77e4f8cd53b15fe94370aae32963ed1686b62949190cf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d46c7277aed9c1ceac69adb92859eddd708cfff97fee2c81926a9b4de27c813c"
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

    generate_completions_from_executable(bin/"docker-buildx", shell_parameter_format: :cobra)
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
