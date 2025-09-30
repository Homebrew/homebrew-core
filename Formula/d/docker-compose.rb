class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v2.39.4.tar.gz"
  sha256 "8f3db575b2533dfc0b04e233050593f0d9a435a117cc8b8653b4e89f0813857c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15421e50a7564a336ff41f9d08a5795d70131b6802f9e98718562fbab6cea45c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef812c7dba7c68ccc12d9f2b6143e940c80ab89612b95a9b0e5a0c09f4317479"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f7f4b72da169d714c0889c740ab34aad72950a2a3e1f8a20776265d8dd074f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "51573d2ff9b0f9157f15ee4f5e89ae749c3252e601e6b575f1c853413a16cd85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85f8805858cbe0dd459dd2a2fa8d607cb74806721ffc6b6b6e1854afdfdbce45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b98698def1d6d6d1eed8d3479b13e616c97cb106e7bd81b8b28ce0988b8964e"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker-desktop"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
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
    output = shell_output("#{bin}/docker-compose up 2>&1", 1)
    assert_match "no configuration file provided", output
  end
end
