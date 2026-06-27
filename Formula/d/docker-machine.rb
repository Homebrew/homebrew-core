class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.51/docker-machine-v0.16.2-gitlab.51.tar.bz2"
  version "0.16.2-gitlab.51"
  sha256 "c68fe259ffcab19ff381d59ed4a59c35716c4362b18bb9a0d0142077235abd0f"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "885e5b9d3c4a31fdbb97f2c84496a5eb16945ef9b2ac5b826cecba67f7a749ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "885e5b9d3c4a31fdbb97f2c84496a5eb16945ef9b2ac5b826cecba67f7a749ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "885e5b9d3c4a31fdbb97f2c84496a5eb16945ef9b2ac5b826cecba67f7a749ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "d24ced9db93d06a301b7101287af85eac9da5fd9a1253d7d03f48a125f8fc456"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93e7fbac8746a6b9bc211cd1da2178dd0762e225c09303c5590786a73891c78d"
    sha256 cellar: :any,                 x86_64_linux:  "3f01b0ef020ee62c2d6b0517e7868a3e32074cac944bdb60a3f9431bbba3a5c0"
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
    assert_match version.to_s, shell_output("#{bin}/docker-machine --version")
  end
end
