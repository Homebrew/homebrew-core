class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.0.1.tar.gz"
  sha256 "5a1b1fdb9681c6f4b39fceab7d7dca12285e72cb55e3d35c31f4659cc939cd2b"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6eac025296098f905ef5453c6a15b8e462719cfae283aaa585ce0ddb8ff768fd"
    sha256 cellar: :any_skip_relocation, big_sur:       "0c4315002e6aa8883201184b52828bb3627e7e2a9fba4e6e187101f5b42b072b"
    sha256 cellar: :any_skip_relocation, catalina:      "0c4315002e6aa8883201184b52828bb3627e7e2a9fba4e6e187101f5b42b072b"
    sha256 cellar: :any_skip_relocation, mojave:        "0c4315002e6aa8883201184b52828bb3627e7e2a9fba4e6e187101f5b42b072b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "057710165181a554e568336bada6ba81a2301ace834457a9e2f22959c8cefca5"
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
