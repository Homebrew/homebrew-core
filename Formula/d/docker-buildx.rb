class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "00b5d5093f6b6cb75fd687988fb395253d10a5ca4d7e4c6b26af3914c219d2d7"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75e97f8219ef27ca2ccb64eea02af1e6ebc147209469847677f33bc657d25008"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d97c86ada5283ddff7b19c165f8508de8acf200931e4fa1b0aecb4f440f3cab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7ea42b2fb605eb5ae159c4136c6ae4da562ccd0a6da603f344e2ce7588361a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5a9bb1c92a9a3b978af0c188b17325f9b782230f435eaa04d259441dbe001d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44a566d46958cb847b6792b68a9bd1c27aa8a5d432c2707b7c0706b069970ced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0553c58a94b8958d26eb46f40b1058b4d23a50cfc8768318e3694cf2a34e3b74"
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
    assert_match(/(denied while trying|failed) to connect to the docker API/, output)
  end
end
