class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "a5103b5b1e4b8ca785445917d4ead07885cd0ae376fbe73fdb0061d26312eab0"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "221d5fcc1ee4c40f2ab342cf35ca2c5179225eb2f2da853748e74a6cdf04071e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c95fa0dde24558092855147d18d678f5a66b574ccaa39eb77cef84c58bb7247"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c48bcaafe1ba7987b3a6d9e6754ac1682c3cacc5ba2cd87ff62987e3746e255e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f39e57dc6c2fafcd438a12221171bc4d4051c77045b4816b632e68004efebe8f"
    sha256 cellar: :any_skip_relocation, ventura:        "feffb4c6ece4f5946550dea8f4f7cc2b7ebdbb5fa32862b7710a7ed553aec826"
    sha256 cellar: :any_skip_relocation, monterey:       "92af273d13a9ab243d01b90ee814f9f8d7cc2fcb84f79f8188f2429c85a3536e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58c67c5c786e85d6a567c9bd1a24c1834fef312697b743a574946f3436424b65"
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
