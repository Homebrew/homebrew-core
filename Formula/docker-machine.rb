class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git",
      tag:      "v0.16.2-gitlab.18",
      revision: "cd8285a7e2310276c7d20575f15bba40a0678ed9"
  version "0.16.2-gitlab.18"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6b906ed87831675cefbd6554179ada9005d798a07bbe93d9f394e1ffe83e77d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26bb4c56e7e1d8c243bb36d8d379c25dce0a2e072454536b3b7336809adb065d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b511812e5c84d52bfb13b2d75c6a1f3755ff7836feceabb43dcf4229b66397ef"
    sha256 cellar: :any_skip_relocation, ventura:        "724dafc5b67297498abb814963f6e0b3fdcd64a7a314888d2b2e6deb176b0674"
    sha256 cellar: :any_skip_relocation, monterey:       "4a413a0dfcbab114ef02c827794493b0c24bfc6c1dd460f5e5aec07a15f75742"
    sha256 cellar: :any_skip_relocation, big_sur:        "241213a65251e486711b8bf8c2ec7eb38ed5c1daae7cf699f109115136a0e38d"
    sha256 cellar: :any_skip_relocation, catalina:       "7496ea458a1554bb41cdc8b1160d9489adcf6ade5aa088990b513418c4b340f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8853013718f57eb34f8ed2c9b177d32bcec9e06e1dd1097af7ac13f40f24a4d"
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

  plist_options manual: "docker-machine start"
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
