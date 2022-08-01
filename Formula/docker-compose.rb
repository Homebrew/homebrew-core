class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.9.0.tar.gz"
  sha256 "582f3dacb3e96e9a07ff3b9d137b508377a769309b84f6faa8722d7f5a226353"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a450c2865f11aabc9887aa98973c191b54fb8f6a46c41348c02317a4e58e204"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a450c2865f11aabc9887aa98973c191b54fb8f6a46c41348c02317a4e58e204"
    sha256 cellar: :any_skip_relocation, monterey:       "85167d4a2aa40393b30c96a58db4dd80d03b53099eb7184d088ce7a57354c888"
    sha256 cellar: :any_skip_relocation, big_sur:        "85167d4a2aa40393b30c96a58db4dd80d03b53099eb7184d088ce7a57354c888"
    sha256 cellar: :any_skip_relocation, catalina:       "85167d4a2aa40393b30c96a58db4dd80d03b53099eb7184d088ce7a57354c888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d877d23f82075f2721598d243cad48a7a80ef4c3da99c6849fbb57353fb9c265"
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
