class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "0014b23382a50c90f91849e491500568366052882e22011822ca2d8a3b2976f2"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "960aceda68c6bb0d2c73f70180019a2a93b20fee543a62e93ef2b471c4dc466c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c01f74758e1beac8d665ecb47fdc601b633f31627073ac6b2a92049ba554f829"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37d730b41cce145cf068653a8a62a658b76b4af61a2c0aac56a6c9da2e480812"
    sha256 cellar: :any_skip_relocation, ventura:        "7542b1c167c25cab65fc5ebef9893d391de14ef7083be7cf8be34a350f2a4f45"
    sha256 cellar: :any_skip_relocation, monterey:       "98f9e09247d32ceeeb8f9e32caefc8071f1222407389eb60de8701104f0c1391"
    sha256 cellar: :any_skip_relocation, big_sur:        "c75ed90776b03f478963418ba1c87d79737c3b9f122d0fd9e60c1d5106b679f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af25e3fc2252595bae6cb76880299f9e1565c3e4357dd1527fc3c09cce6434f5"
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
