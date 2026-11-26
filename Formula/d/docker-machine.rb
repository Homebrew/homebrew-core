class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.68/docker-machine-v0.16.2-gitlab.68.tar.bz2"
  version "0.16.2-gitlab.68"
  sha256 "5073ecbd7e6eb3d0a0fee349c63113f03ed25e982d2c924cc1aae088c9827d02"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  # Allow autobump to update formula until end-of-life
  livecheck do
    url :stable
  end

  bottle do
    manifest_sha256 "bae9b8db53c274da7b434907c26a2e8eced5aae96f707436e4a93484e3afb3d3"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3766499751c70767a51333ecfc6ba5d6c827016c7ee34ef00987a0741f5bdd97"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3766499751c70767a51333ecfc6ba5d6c827016c7ee34ef00987a0741f5bdd97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3766499751c70767a51333ecfc6ba5d6c827016c7ee34ef00987a0741f5bdd97"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4c8e9ad0668ce316b051bc55cf36710ed70b65a83982f913b242a6afcbe1befb"
    sha256 cellar: :any,                 x86_64_linux:      "63ffcf3efb2e9b79a3202543da265bc52eef1bae3c2d8ad8d51a6129e5852632"
  end

  # After Docker ended support for original docker-machine[^1], we have used
  # GitLab-maintained fork. However, the fork is now officially deprecated[^2]
  # and scheduled for removal in GitLab 20.0 (May 2027)
  #
  # [^1]: https://docs.docker.com/retired/#docker-machine
  # [^2]: https://docs.gitlab.com/runner/executors/docker_machine/
  disable! date: "2027-06-30", because: :deprecated_upstream

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/docker-machine"

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
