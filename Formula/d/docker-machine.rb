class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git",
      tag:      "v0.16.2-gitlab.22",
      revision: "0420c7034000647eac3afb4c3ca0f562a0c08c7d"
  version "0.16.2-gitlab.22"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0f6a3cd3c6d90719461684ed278c8a59f29dbbdb6abefb066b18f8d857ff0fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f63782732882e6940e7fe589aab96ea3d870baaa88d2701ea997c7b684368d5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b54eb04f4da8d746d19d531325e3baccbf47fef21583d44a97d3771ad22be714"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d63cee6448fb415848c8d65db1593f292b5776f0e93592ccdc01d68a327f178"
    sha256 cellar: :any_skip_relocation, sonoma:         "22e20fb3b61c5c61294a1f291d06a54b6980816d7bc782a107ad5f6c36d5eb58"
    sha256 cellar: :any_skip_relocation, ventura:        "c7d2f76a4093ce92659cb975fa8a95b55e45b15bc08c93c24b3d809e121d862b"
    sha256 cellar: :any_skip_relocation, monterey:       "ce172e2635cd3fe81c637fcfae5110fada9cdef4d73c349636b6e8ee9e8b7bd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "963ba7b893608dabe76a6c59ca054bf64814759ef2a01e05ff537b0ca7e4831b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c430f4fe92cd2347730e27795ad3e7612338f774a631a6b57fe41e382856e075"
  end

  # Commented out while this formula still has dependents.
  # deprecate! date: "2021-09-30", because: :repo_archived

  depends_on "automake" => :build
  depends_on "go" => :build

  conflicts_with "docker-machine-completion", because: "docker-machine already includes completion scripts"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/docker/machine").install buildpath.children
    cd "src/github.com/docker/machine" do
      system "make", "build"
      bin.install Dir["bin/*"]
      bash_completion.install Dir["contrib/completion/bash/*.bash"]
      zsh_completion.install "contrib/completion/zsh/_docker-machine"
      prefix.install_metafiles
    end
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
