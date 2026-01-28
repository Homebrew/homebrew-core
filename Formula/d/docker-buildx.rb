class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "2f2069554305c9659dd4a2b4eb10c7aeab97e52e89cfeeda07f0c0c43d19ee80"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b87538d4e185a90bce14837d486d5caab60fc1776cca3c36840b007ad95aecd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d553c2095622bc3a7c042d73aeb3e42c198409c7fc4c19fa94736354fc987e75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0d573f4ec445ed3a9ec7ff6426e8656523b632d58e755babffc77653c6d71e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "568c280eaa1d45eb2a0bd52754d9d5a175153015bc66e1692f19475b8fc9ce42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b956d09fc479026441d8ec631b886fb1a4b20dd8f7352872f8d888c6c3c626f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81b902315f0904e4639060f164c56d3c12b3a93d571c80540b326ffb5d046b5d"
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
