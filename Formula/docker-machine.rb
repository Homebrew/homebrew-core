class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git",
      tag:      "v0.16.2-gitlab.20",
      revision: "9e9d6baf7eda8b6569f92e777ae7f496599fb297"
  version "0.16.2-gitlab.20"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1588f6f87758aa13b8cdb77a59e76dea0c6ad003bac898885274633424a37fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b930b5b5ebafb59fc04043f970768274065108ec5df62f627aa7fbb6b7fb9491"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "518c5afa8035aa2f00eb005a367b1ca0045057f01704f49b4591515fead02ec5"
    sha256 cellar: :any_skip_relocation, ventura:        "0cf116efe43960673f18a4e78af02659c6d560ea836cb94b8478cd768cc64f72"
    sha256 cellar: :any_skip_relocation, monterey:       "66783b1ca84e4864268b34c1727009126dc9366015ec80768fbeb6a5d412e609"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ddbc061da1456443d972e1248556d6ab5656c061524a361d254968fdcd0370e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e95f2fb1e8a7cbcebdc60b5959498aa32123dbc8287d03c84c36d7e0ca7d6f4"
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
