class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v5.0.1.tar.gz"
  sha256 "e48ebd8c71bb805c0b97b9705ac03513e9a0c872fa73cb0525141d0f49148b5e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4469b4bcea1a3abd32b3ab2977eae28942d1721fbdd99d50e507a19efc3fee99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e4eff1f50d2067a9394964b9d637f85b623fb1e68771042258c8060974407c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a14dab1af51c0bea09d811b346e5555f44552c55a9c7386e51c993a1f2ef85e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2163f30fc87b4091013d4ffebbd5572b31d372a912d3dc373a5cd88402675f5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4f4c94b3536eb424890b0c1090cad5ba93e747e48938b60a5deec67f779c64a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a8aa4cc73906042903b798f449022f561d5169a37c28df2317a624f131ae91d"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker-desktop"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X github.com/docker/compose/v#{version.major}/internal.Version=#{version}
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
    output = shell_output("#{bin}/docker-compose up 2>&1", 1)
    assert_match "no configuration file provided", output
    assert_match version.to_s, shell_output("#{bin}/docker-compose version")
  end
end
