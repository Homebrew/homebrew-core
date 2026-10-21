class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.63/docker-machine-v0.16.2-gitlab.63.tar.bz2"
  version "0.16.2-gitlab.63"
  sha256 "0144733564f8a45ab0a044710f89f7a4ac053d938dc07aef34fb0b69ae458c88"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  # Allow autobump to update formula until end-of-life
  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0312462b1841f4d76d74aef1335417a81485eed64343fb3f506c0ab722a364fb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0312462b1841f4d76d74aef1335417a81485eed64343fb3f506c0ab722a364fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0312462b1841f4d76d74aef1335417a81485eed64343fb3f506c0ab722a364fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0c2ce38d2c6f842eb4c146698b15f7abb25bef4431305b895fc7edfadb42e2b3"
    sha256 cellar: :any,                 x86_64_linux:      "8d5bfef012854b9e19bad78e4b7893f59d34f46d2fb965b538a5b8bd182f7d82"
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
