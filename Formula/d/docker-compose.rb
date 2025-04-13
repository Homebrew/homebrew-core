class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v2.35.0.tar.gz"
  sha256 "37911c6303252c42d316dd5898b15b7e7054a9170d3ca2aafa2c5fce5fb6ec26"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85d6a466b5514358db6f83af609f71cae4b32632105a53d0a93bfc0028934559"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51a5725bf8104acaf56b30394e700511d6a1b77d0cabd96806cf294e1ff67ceb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd8b922861e608abf0a62f805eb9ce47dd9babd512eea0a457de2b895ca479d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe32c99a1c0201c3523f03ded8f7f86847f4f0a3c5d039643c9bd81634fa7aba"
    sha256 cellar: :any_skip_relocation, ventura:       "aeec46cc0cd38ea77dab32d474b89c99c3e69f393115d37bc9ad31092137c5d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c6b430a3f0c898cc4dc1e882f21e57590157a3dec8156bb09f1888e54403cc0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/compose/v2/internal.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd"

    (lib/"docker/cli-plugins").install_symlink bin/"docker-compose"
  end

  def caveats
    <<~EOS
      Compose is a Docker plugin. For Docker to find the plugin, add "cliPluginsExtraDirs" to ~/.docker/config.json:
        "cliPluginsExtraDirs": [
            "#{HOMEBREW_PREFIX}/lib/docker/cli-plugins"
        ]
    EOS
  end

  test do
    output = shell_output(bin/"docker-compose up 2>&1", 1)
    assert_match "no configuration file provided", output
  end
end
