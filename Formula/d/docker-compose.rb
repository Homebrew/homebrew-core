class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v2.35.1.tar.gz"
  sha256 "999f5e3405c8da64f7296d8e90b6777a2ce7f3a582b4b1800a7a1c21dbebaf16"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a079c55b6538a2e858e072dac52ff048c9df7b70acfade6b0e5a8339337b095"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba32cd9bb7761d9ad34a36c7dcf8d1aecf725dbedc02f93f5a53d871999eeb04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52107606093f3e6ecd4005c9f7264a81e88f6c41d2e6dbaa27b6bddbb4250cbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca9c64fcc38fde7bbeb1577b4cb5277ae4c8e6513bd9ca3f096b43c991870206"
    sha256 cellar: :any_skip_relocation, ventura:       "68fdb4fe62f06b556649a375f43efcdd65b9998fee94c069f901fd87e36dfdda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e707513799718760ed20a5a40d1766bd07bde7b43fd48d486d86488f122d4bf6"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker"

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
