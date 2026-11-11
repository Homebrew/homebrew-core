class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "45aa68ee053b9bfa3c82f3dc7a2562e118be33e20ac87f572fa6e9f3d9ad67da"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "66f42af9f283b0e42b20a0ae8add21686e3eb77e3edd217b0fc6bfd034f85fe8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "66f42af9f283b0e42b20a0ae8add21686e3eb77e3edd217b0fc6bfd034f85fe8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "66f42af9f283b0e42b20a0ae8add21686e3eb77e3edd217b0fc6bfd034f85fe8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8529ce60dd09ac3354935b821d27baf9794ab35aecf22ec1842ca53370d23382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "38b776e4b9786485d1c690fae56a6c2d3cf9e5dcb27118931849d9115b9f4aea"
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
