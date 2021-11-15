class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.1.1.tar.gz"
  sha256 "5c9246c34cafeb51b3289c016cb2cbdd08b3eda87b0f8d4cc02fd7630cfdbd7b"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d1eb06fff7f645293cbe34fd0d2f774be8538f62b58bdaa6908b84f2b272402"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d1eb06fff7f645293cbe34fd0d2f774be8538f62b58bdaa6908b84f2b272402"
    sha256 cellar: :any_skip_relocation, monterey:       "c520d88df10ca7317f07a8db5f2a6247b331c81f262d969e42561b3283b9d384"
    sha256 cellar: :any_skip_relocation, big_sur:        "c520d88df10ca7317f07a8db5f2a6247b331c81f262d969e42561b3283b9d384"
    sha256 cellar: :any_skip_relocation, catalina:       "c520d88df10ca7317f07a8db5f2a6247b331c81f262d969e42561b3283b9d384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf95955a3a91249a86bab809277446f0e0a48985e43994b369cc38b33f0a452f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/docker/compose/v2/internal.Version=#{version}
    ].join(" ")
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
    assert_match "can't find a suitable configuration file", output
  end
end
