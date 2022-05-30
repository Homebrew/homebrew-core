class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.6.0.tar.gz"
  sha256 "b01b998dbc29478ec989a9df4ebaf4017b7406bba1847b061632f0a7a9841751"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27098f447a7745291b696da8b94966edc5b4fec777d8faca58c321b0d03d535d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27098f447a7745291b696da8b94966edc5b4fec777d8faca58c321b0d03d535d"
    sha256 cellar: :any_skip_relocation, monterey:       "cee5d897c34c97dfb075f7b54d12a86db8428cf4bbf438d5a5cf6a1b45fdbcf1"
    sha256 cellar: :any_skip_relocation, big_sur:        "cee5d897c34c97dfb075f7b54d12a86db8428cf4bbf438d5a5cf6a1b45fdbcf1"
    sha256 cellar: :any_skip_relocation, catalina:       "cee5d897c34c97dfb075f7b54d12a86db8428cf4bbf438d5a5cf6a1b45fdbcf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27239f27885dd8a70b65cbce04cefeee4d689309c8332f3a35c3e6e5bd72d269"
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
