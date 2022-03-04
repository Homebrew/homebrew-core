class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.3.0.tar.gz"
  sha256 "a602aa3f4fb9d71dbcbe26d8cd32733549f45910d6e9f7090a8ed01be53a6c4f"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cccd370674458075325d199f4ebcabe3a34824a6dbad8346b96cdabda1fd0a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cccd370674458075325d199f4ebcabe3a34824a6dbad8346b96cdabda1fd0a9"
    sha256 cellar: :any_skip_relocation, monterey:       "af736ed84076648e371bd5016c0f511e3cad3670b2eb1e17f3a33d0ecdb69fb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "af736ed84076648e371bd5016c0f511e3cad3670b2eb1e17f3a33d0ecdb69fb8"
    sha256 cellar: :any_skip_relocation, catalina:       "af736ed84076648e371bd5016c0f511e3cad3670b2eb1e17f3a33d0ecdb69fb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d222b0d3495bf8dde607c3a721f1556d9e2749e6c83030d0665312f7713ab011"
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
