class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.12.1.tar.gz"
  sha256 "80cd5cc7b7863026890fb54d1d7314ce42e42ae6971206c80ad2a91348d443b9"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4ece577da02b258063a3a5a8ec24a31c47914b8a66cda54fa99c02b13455f71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4ece577da02b258063a3a5a8ec24a31c47914b8a66cda54fa99c02b13455f71"
    sha256 cellar: :any_skip_relocation, monterey:       "bd61fd2f648efecfd12fecf294abbe86745938e41c69204f8b96de0707075007"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd61fd2f648efecfd12fecf294abbe86745938e41c69204f8b96de0707075007"
    sha256 cellar: :any_skip_relocation, catalina:       "bd61fd2f648efecfd12fecf294abbe86745938e41c69204f8b96de0707075007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed7ec6f7181571641230ceeb1f1395a370367d09638c09e1f927add2831bfe65"
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
