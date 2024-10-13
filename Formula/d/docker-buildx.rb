class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "a1c81f386142908d4984836fae75b5aa37e1921e7186ec8a548c54be62fece43"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "609f730177ff2dcd1dbb7275d0f0f3c888627c6bfb20cee8d66c7e8645c6a4a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "609f730177ff2dcd1dbb7275d0f0f3c888627c6bfb20cee8d66c7e8645c6a4a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "609f730177ff2dcd1dbb7275d0f0f3c888627c6bfb20cee8d66c7e8645c6a4a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "cde1988c799527007adc481e3daa5d3012a7140073585dff7a069e5d46587cc0"
    sha256 cellar: :any_skip_relocation, ventura:       "cde1988c799527007adc481e3daa5d3012a7140073585dff7a069e5d46587cc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89c893e48e4996d48439218e4b59d67b0b238e5f86a961d802c437cd5f50cdb1"
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
