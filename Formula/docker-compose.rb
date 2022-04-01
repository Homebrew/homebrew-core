class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.4.0.tar.gz"
  sha256 "b0507aed3b86900f5199309dcfb8b2d4081d94e8ec045eec2bada8280dc9901b"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4548d39ff63bf8fff5c33df16d7b30e445b957ddc3faf7191e365527eaac7f7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4548d39ff63bf8fff5c33df16d7b30e445b957ddc3faf7191e365527eaac7f7b"
    sha256 cellar: :any_skip_relocation, monterey:       "d1d602456c16ff4509e058f7dd6e1b33ae2781ee1b03f91badf05ffb435c12ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1d602456c16ff4509e058f7dd6e1b33ae2781ee1b03f91badf05ffb435c12ee"
    sha256 cellar: :any_skip_relocation, catalina:       "d1d602456c16ff4509e058f7dd6e1b33ae2781ee1b03f91badf05ffb435c12ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b93a1c012ee20d88be30d56972f5cff51df6609c765945e5c3ea2e947ba2e2b"
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
