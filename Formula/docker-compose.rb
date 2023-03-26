class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.17.2.tar.gz"
  sha256 "d6e6de858ecdb0104991c86c66dde5dd4fb6a1160d707308d8ad3167450c8094"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "439df86d94fc88f134213b168381c46f13f4f196fc48e94b99df1011336f7cd9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "678b6fa369a7f0c8b5caaf67c7136a8b4573fb4c8c42e81d7e2929ba2af4b1d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e7deab195d41c1f5d8dfa04070e21001af187d0dcf7b3f8b58ca61adefa879c"
    sha256 cellar: :any_skip_relocation, ventura:        "7723f2e2b124e798e5c7fed364788d02143c7b015a09825550a4a3cdfbd92801"
    sha256 cellar: :any_skip_relocation, monterey:       "cb504e6144289a08d0250be4251fcd05bce2cd260b633f179c55b241ed278811"
    sha256 cellar: :any_skip_relocation, big_sur:        "01973bc69480f9228747b52ff1377542511e7d66688a9fd93d30627dfda7fbb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "865d7635031c79142c76c597436ef6891ff875d7e744ee2a33384856f2cc08c5"
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
