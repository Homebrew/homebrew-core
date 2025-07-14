class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.39/docker-machine-v0.16.2-gitlab.39.tar.bz2"
  version "0.16.2-gitlab.39"
  sha256 "11e8bf4a3a8527157bb7fdf3b1c998881cccfc2d458d72bf2eade7190daba34e"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13dcf18506e0de9cab1eb6810abf4f49f8803255d3f375f5d9ece7e3466914b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13dcf18506e0de9cab1eb6810abf4f49f8803255d3f375f5d9ece7e3466914b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13dcf18506e0de9cab1eb6810abf4f49f8803255d3f375f5d9ece7e3466914b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc142e0c9a32759a4ff4dba798fbbaadf007fd39690aeb6c094c40ca34147d78"
    sha256 cellar: :any_skip_relocation, ventura:       "dc142e0c9a32759a4ff4dba798fbbaadf007fd39690aeb6c094c40ca34147d78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1118a8a5a2c980203decad0c106e3f99521858815ea29e663c51959c678a86b0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:), "./cmd/docker-machine"

    bash_completion.install Dir["contrib/completion/bash/*.bash"]
    zsh_completion.install "contrib/completion/zsh/_docker-machine"
  end

  service do
    run [opt_bin/"docker-machine", "start", "default"]
    environment_variables PATH: std_service_path_env
    run_type :immediate
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output(bin/"docker-machine --version")
  end
end
