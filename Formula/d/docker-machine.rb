class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.67/docker-machine-v0.16.2-gitlab.67.tar.bz2"
  version "0.16.2-gitlab.67"
  sha256 "b19356574e62b81fcce8df9b63b4b6c953ceeacd87e449a308112ceab0ed2eec"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  # Allow autobump to update formula until end-of-life
  livecheck do
    url :stable
  end

  bottle do
    manifest_sha256 "9a32e50af39f281601706065f8eb820c6aa71d71d49a111fef3b7f7b960207b5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cde2c42cce6ebaab93d59040a40025d315039dd6a934da2dff40d86eed9be21c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cde2c42cce6ebaab93d59040a40025d315039dd6a934da2dff40d86eed9be21c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cde2c42cce6ebaab93d59040a40025d315039dd6a934da2dff40d86eed9be21c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e8e8c072327a8234cfd82af22578087601a92fe34e9406656f5f47ed5531766f"
    sha256 cellar: :any,                 x86_64_linux:      "1b887d0b37be931299a4e1c3091c052e39f423d06390fe634086f2806c7adbb7"
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
