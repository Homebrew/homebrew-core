class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.1.1.tar.gz"
  sha256 "5c9246c34cafeb51b3289c016cb2cbdd08b3eda87b0f8d4cc02fd7630cfdbd7b"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58d48d019a76bc87a00dfd01a0cfe29e7695b3a78a0cf498b910959e0bc2fa36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58d48d019a76bc87a00dfd01a0cfe29e7695b3a78a0cf498b910959e0bc2fa36"
    sha256 cellar: :any_skip_relocation, monterey:       "edb818a881044bb8f4bd2e6ee24608a69ae554a90ee94adaa5a87c3aaa634a54"
    sha256 cellar: :any_skip_relocation, big_sur:        "edb818a881044bb8f4bd2e6ee24608a69ae554a90ee94adaa5a87c3aaa634a54"
    sha256 cellar: :any_skip_relocation, catalina:       "edb818a881044bb8f4bd2e6ee24608a69ae554a90ee94adaa5a87c3aaa634a54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "717cc79fb5b6e619c787314fc38f9df5460eb720ab98203a9ec87bd02e70ccd4"
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
