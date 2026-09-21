class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.55/docker-machine-v0.16.2-gitlab.55.tar.bz2"
  version "0.16.2-gitlab.55"
  sha256 "706a897a1db8a6a6eede7abd465e9c74218d6ae129efc894b5582b6f6a0d6109"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  # Allow autobump to update formula until end-of-life
  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "83934f4cf8cdfb9fec6913e7d089306d49d820a669281bc8bdc12dd8c0182031"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "83934f4cf8cdfb9fec6913e7d089306d49d820a669281bc8bdc12dd8c0182031"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "83934f4cf8cdfb9fec6913e7d089306d49d820a669281bc8bdc12dd8c0182031"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "df067d0fa062f9dfe01ed1d5347fc16541e33f5aa607b13fe4bcad5d33d38593"
    sha256 cellar: :any,                 x86_64_linux:      "dd711cab530e268e87049ec48172dbd5a0468d6ff6c473f9a8c858d3bc8b8c13"
  end

  # After Docker ended support for original docker-machine[^1], we have used
  # GitLab-maintained fork. However, the fork is now officially deprecated[^2]
  # and scheduled for removal in GitLab 20.0 (May 2027)
  #
  # [^1]: https://docs.docker.com/retired/#docker-machine
  # [^2]: https://docs.gitlab.com/runner/executors/docker_machine/
  disable! date: "2027-06-30", because: :deprecated_upstream

  depends_on "go" => :build

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
