class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git",
      tag:      "v0.16.2-gitlab.21",
      revision: "77bd8f5891e9808ae1cbda2e7cbfc7f661bfed77"
  version "0.16.2-gitlab.21"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ab4a365a81c6d62f36a845275303001c4cd46a3399dc771aec48d9d42a88ded"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf02b61e39fca0d55566c3bf256336bdfd1eb7a75a242ebcff9c7b1900525491"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b055697fe03a7756e31c7c85cdc102e8a2939497d991064b9f41c2bec8d3a8bb"
    sha256 cellar: :any_skip_relocation, ventura:        "9c123239926ffaf547194617a53a7ee6dcb07d3224c2cc991659e216d08a9ab1"
    sha256 cellar: :any_skip_relocation, monterey:       "8b85222137a669dcf3def6be8fd52693be915d441201dc7050f1cdc19c149470"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f61fa7c797d4e65eac94618c15689084c415dc6e9abe9b0018c935dabb48f99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9522c86150d8741bdad3f9452975fecf4b4767108e85bd0416264e3b90a6fed7"
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
