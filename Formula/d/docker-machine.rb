class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.52/docker-machine-v0.16.2-gitlab.52.tar.bz2"
  version "0.16.2-gitlab.52"
  sha256 "1d67717a83f53e409e1555642af44a1797e1f3d64cc80211599ede19665f9e79"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  # Allow autobump to update formula until end-of-life
  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aba2cea8fa59c13524831085b70b12467011c4b86f21526cc3e56308404ada79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aba2cea8fa59c13524831085b70b12467011c4b86f21526cc3e56308404ada79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aba2cea8fa59c13524831085b70b12467011c4b86f21526cc3e56308404ada79"
    sha256 cellar: :any_skip_relocation, sonoma:        "869557b665f17804e1ea1b88ccfe5d67532f0f387bd3543d4169d94ce2b927bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92a13bf3d0d5beccb79fd560892d9fffa7a0428984d851c27298e57fc8ff08d0"
    sha256 cellar: :any,                 x86_64_linux:  "a0e24a69e019195f3ecc247fb89dbd12b3d0bec27a8493afdb169f8ccac2bef8"
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
