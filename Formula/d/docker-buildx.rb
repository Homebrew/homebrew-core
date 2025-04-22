class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "a6c8d86c55a733ddd6aeac8da0624aa9d0cb966846e955399f5a075590499fd8"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f92472a84386d23b5bbd6ad9aa1fe86da0be4a0ed56320a5b44905a7f908cc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f92472a84386d23b5bbd6ad9aa1fe86da0be4a0ed56320a5b44905a7f908cc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f92472a84386d23b5bbd6ad9aa1fe86da0be4a0ed56320a5b44905a7f908cc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "70b2fbba98abe71c5613168f9ed3eda9fd268997e0b1696028bf9006f45f8803"
    sha256 cellar: :any_skip_relocation, ventura:       "70b2fbba98abe71c5613168f9ed3eda9fd268997e0b1696028bf9006f45f8803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8905c276a25d3ebc57adbbf411ed196bf9c13be7ce2d5c333075e321d07e429"
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
