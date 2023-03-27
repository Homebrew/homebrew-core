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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55fa7fd29ccff1a8e3d77b16833d31b9fa900093d6b0ebd4256f1e7d850dc933"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61e172fad07a28f9c8a5fad7e0c003de0577280f5058179c79282658f7a25dbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "625733210b19c9f89a2f340e27c67b4ae6fd09cb37fc66f5dc374b7c091ff9d0"
    sha256 cellar: :any_skip_relocation, ventura:        "e678125c0430ea97801ce5e7eadb41f69eaca4504c0ccc99109f5825fe12b2f6"
    sha256 cellar: :any_skip_relocation, monterey:       "693c21bde6179df20ed08b99adb496ab9d2e7a0569ac93f6dd9d77ca2f9efd6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5361973b9dca060be463bf43ca5a484d3a560a610b97903df71cc43d40ac99f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3666a0cd976b5a8c696fcd837eb54d940cfbc1311fa23996b1224c7351658756"
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
