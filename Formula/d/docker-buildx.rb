class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.36.1.tar.gz"
  sha256 "8959987919445ab61564f50decde4dae810137063d84e2d3c969c9a4a68ecdeb"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df6823aae7eb4f2b9b70e2282f24c5b37f204483b6c2cb2f75c3485b7e4decbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df6823aae7eb4f2b9b70e2282f24c5b37f204483b6c2cb2f75c3485b7e4decbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df6823aae7eb4f2b9b70e2282f24c5b37f204483b6c2cb2f75c3485b7e4decbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "df0c110b3832d58d66f7c9d60187f8f269bcaa81f461ab4f719468348bd6ae5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ee75d42106649818625a3457ee2d0b144d041516f07c6cd8bc1f9edfdcb16ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28609e0af08bef6423475f6dac7ef61b5c8601fe3e819c552cc2035042416875"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
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
    assert_match(/(denied while trying|failed) to connect to the docker API/, output)
  end
end
