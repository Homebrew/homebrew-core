class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.3.1.tar.gz"
  sha256 "f62df6ca883e28d6a6caddb4b55eae102156c562b611ef90e269b47af1273cd7"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89c9467de51d79653e54ef5354c68589c6d576edf98252822b72f51fdb5b094c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89c9467de51d79653e54ef5354c68589c6d576edf98252822b72f51fdb5b094c"
    sha256 cellar: :any_skip_relocation, monterey:       "6fc611d07ad60cd05def9e477922337c0dcc7adfc96bda7c20bf060cf78f54f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fc611d07ad60cd05def9e477922337c0dcc7adfc96bda7c20bf060cf78f54f2"
    sha256 cellar: :any_skip_relocation, catalina:       "6fc611d07ad60cd05def9e477922337c0dcc7adfc96bda7c20bf060cf78f54f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ac6b206ce8a76fbb22bb6c92aed0df591270203a412f088231dc8f1e3eeeda9"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
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
