class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "c8eb34392910bf18a858d4099e841deec2f7ea433bb3ed230082f55b69f19118"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5bd47c9bf1d207737ebcd770e39defcd7f621133ea110c5ce6a1dfd26dd9171b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5bd47c9bf1d207737ebcd770e39defcd7f621133ea110c5ce6a1dfd26dd9171b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5bd47c9bf1d207737ebcd770e39defcd7f621133ea110c5ce6a1dfd26dd9171b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0cad37627e955d0a6c45e16f2d6cfc92826454644a757275115f1904e3c5e5aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "054200d861bbb83c9d3a5dbc280b8c7c77d52fdc9ea18d4417c9d0f8a4968ba7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
