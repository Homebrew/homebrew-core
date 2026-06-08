class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.48/docker-machine-v0.16.2-gitlab.48.tar.bz2"
  version "0.16.2-gitlab.48"
  sha256 "d32358543bce4fc6356ed0edbe8ee85045fadecbc8c3c660ea56df43a181bb22"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e1e6525329318f9a7d961679015e0fbdb868a864305fc3821e55a18f4452a2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e1e6525329318f9a7d961679015e0fbdb868a864305fc3821e55a18f4452a2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e1e6525329318f9a7d961679015e0fbdb868a864305fc3821e55a18f4452a2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "89b4d604b6fa351f7917e7c7890d403f7bf58ec994429f74f55b57d758866b26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7453306615d829f1161dac3606f8f57a1a08fc798bae52fb3c8d574c8cd26348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b855c38e6b0a2734058a724bddd717d32e961186bdf5b70e32b6d218bd6fa362"
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
