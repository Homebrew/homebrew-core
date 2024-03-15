class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v2.25.0.tar.gz"
  sha256 "9c8185f241911f5d8bdb25d8c735fb1f37f3573c17e25d5b1a942df2e78e49ea"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ff10e5c0d3dbcaf290805ecc037983d9b92d99ef90ab8488b1bd421bfdd6e77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a74c6110dbb58b14ce19b55ec6d8006563f91cad4b6134a97e755294c7d823f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae541e06cb8146f8f318e0c37a627896d0e18a70a9e4dabbcfd9107294930108"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2a8843eacdbe824b94d5e0fc853dd0486b8ce2a0180665acac82b786b9e6a1b"
    sha256 cellar: :any_skip_relocation, ventura:        "eafa98f565814abfede00c74514a1107096fd9be4e37b5b1298ac0504dd9b6f1"
    sha256 cellar: :any_skip_relocation, monterey:       "04140046f946a5e09d3730409fc377abe34083a2d9f0ea8b5a5bff4bfaa9664d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfa19aec65e83a1e59e1a746ccb7ccec940f77be3306534f3e2df26da7f536e0"
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
    output = shell_output(bin/"docker-compose up 2>&1", 14)
    assert_match "no configuration file provided", output
  end
end
