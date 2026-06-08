class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "907846895a843d1dc4fb6962f05567b0c279a2eca83be7461b5928125ebdcc51"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bebcd07fe45507a6a683a7ba895e0b2afdbf7d0f3faf4fd53b0a9b77a583e5d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7220c4855d8ffd86ad7c27c7b13c91691149100cf6f0dfeae4945be7bab387f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5876608a810b52d337e3aa77ee0ea42f4bd4fa9e1ea9f0c50533b15f7d2ba57"
    sha256 cellar: :any_skip_relocation, sonoma:        "43216dffb2fb9e3d473f10b414fa9fa3a14484d4b508dd38062d87d3149856f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4d5078885a076b17ab03b4376afd891584488c68cd505be50d09d683347e2d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b804de2efab523ca81d33a2250d6514216a476da8ba42ced1e31ee832cbbea1f"
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
