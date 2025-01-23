class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "a454cc4e9522bad4b0d1f95aeb57f244594ed1e3fbecbe54080ce762f1942dce"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d105684564f206fef9c27278a23c1671a440ca965e4130c723965d47ceffffa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d105684564f206fef9c27278a23c1671a440ca965e4130c723965d47ceffffa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d105684564f206fef9c27278a23c1671a440ca965e4130c723965d47ceffffa"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfbb7fb81c631ef02e10a5d1662459203252862fcd7e210ef6a238c0c3194f80"
    sha256 cellar: :any_skip_relocation, ventura:       "cfbb7fb81c631ef02e10a5d1662459203252862fcd7e210ef6a238c0c3194f80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d42858eff94e4068db37d4800494f437fdfc85f8cdddb5549c6a2fbc9a6dd7d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/buildx/version.Version=v#{version}
      -X github.com/docker/buildx/version.Revision=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/buildx"

    (lib/"docker/cli-plugins").install_symlink bin/"docker-buildx"

    doc.install Dir["docs/reference/*.md"]

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
    output = shell_output(bin/"docker-buildx build . 2>&1", 1)
    assert_match(/(denied while trying to|Cannot) connect to the Docker daemon/, output)
  end
end
