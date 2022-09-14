class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.11.0.tar.gz"
  sha256 "fe01c85ad31767c22d5f6ea24e6809f5b675c9253d534138ee4095428dfcb96a"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "056ab56dbfb2ccf80adfdeade5a2e4d538cf4df94d5cda1d4c5daaf59737f999"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "056ab56dbfb2ccf80adfdeade5a2e4d538cf4df94d5cda1d4c5daaf59737f999"
    sha256 cellar: :any_skip_relocation, monterey:       "e53ad8d98f9cae5bf9d8e2ebe094b9508c693bdad0f727a2f00d05e0d7fdc5e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "e53ad8d98f9cae5bf9d8e2ebe094b9508c693bdad0f727a2f00d05e0d7fdc5e3"
    sha256 cellar: :any_skip_relocation, catalina:       "e53ad8d98f9cae5bf9d8e2ebe094b9508c693bdad0f727a2f00d05e0d7fdc5e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fad64189a85d45fd75b641ce41961e5e1e6cbb305401b1cfce09e495279fdc05"
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
