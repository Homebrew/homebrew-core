class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v2.24.7.tar.gz"
  sha256 "f671c42b2189372e2128a0abf218c04cc92693ef8960c3d26aab60bf7ca4febf"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3d1abc968661f35ef8dd117fee878979f15369877572b907fae19737f67978f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f853b8936bbd38d06038a5cd224488baed8a95252c6f8e7b56cb4e9d50a10dfc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7971cb21c11a7939474f2e0695ada87a6273ee527ea9f80e679430d27398dda9"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d68cb11d9c5b5246fa9331eb04fb3e24eff6361cd6cfb8f1fb496d2be04437c"
    sha256 cellar: :any_skip_relocation, ventura:        "d5036b728b915eecf52152e92d077c08180262cc1ace39b4b95c3a8c92682d1e"
    sha256 cellar: :any_skip_relocation, monterey:       "01e31c63145bb165f9a55489525c2da26db8cf18e0ecf925362c2fd1ca2716c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2631e3e7b878bc7c84cdb238b9276be1286e2067b7dd86c880a6b646b056fc67"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/compose/v2/internal.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"
  end

  def caveats
    <<~EOS
      Compose is now a Docker plugin. For Docker to find this plugin, symlink it:
        mkdir -p ~/.docker/cli-plugins
        ln -sfn #{opt_bin}/docker-compose ~/.docker/cli-plugins/docker-compose
    EOS
  end

  test do
    output = shell_output(bin/"docker-compose up 2>&1", 14)
    assert_match "no configuration file provided", output
  end
end
