class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "790e4eb0c98da49c60d2c94cebcd3f1658cd7aca3be82093fcb19b9c1d0ac06b"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb8a00f55798493e9fa48fedd4b5d4fcb4e1c7b3d20451a97c88015320ae77de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efcd40d36bef6b8571440c893b5ff1d033b611775a8f000f61aca33ad6331a59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c5553eb27dd1bb4bd9e4eccbbb3aea980bb37fbf67bc60c55ba3b4fe76c4b08"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb5693bdb0145b8a9b5c2dee9a932f517f2015b0773dd26926ec7bedd12e4264"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34cef927d09d6c710146027df24e60f5541bf00dee8e5203bbdd24c624bdca63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7b1a422409c3112066c3cdb904afc5d9848b11e3ba57b290d73a6924e9d06e5"
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
