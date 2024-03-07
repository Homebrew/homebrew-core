class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v2.24.7.tar.gz"
  sha256 "f671c42b2189372e2128a0abf218c04cc92693ef8960c3d26aab60bf7ca4febf"
  license "Apache-2.0"
  revision 1
  head "https://github.com/docker/compose.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a85a2af139213b029dfce1f1029e38dbce3d385c1d1017b2f0065544861f40d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0771f0911929250c766d65b6ae0751604801f9ec79c96f4a93a9b44296e2cffe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ccf242677d85e0ed17835b95f3b872d24d468f2057743e8e63322b77d274061"
    sha256 cellar: :any_skip_relocation, sonoma:         "09d9821998d1f2ff7543295b0626b4972cda268653537fe293c505dd17cf806c"
    sha256 cellar: :any_skip_relocation, ventura:        "46fdf44d5b90337d004b71398658c452246fbd534018591f09de4928bbabc878"
    sha256 cellar: :any_skip_relocation, monterey:       "b65fdffcfc9b876d5cce74b96d4ca4ec7372de1798e6caa1dd6d67dc102a9518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "911d021784e9e48dfe848a6b143e18a79304e993826479f99d21916194d1fbd8"
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
