class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.36/docker-machine-v0.16.2-gitlab.36.tar.bz2"
  version "0.16.2-gitlab.36"
  sha256 "bda8b89272aceab6f91e4ebc2b026cb6285e23e0b71ede0230c814f6f3c80bb0"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7dca3494e255605f551cf8ebc6c3482a34a306bb70ce62792128bb81caff4a25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dca3494e255605f551cf8ebc6c3482a34a306bb70ce62792128bb81caff4a25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7dca3494e255605f551cf8ebc6c3482a34a306bb70ce62792128bb81caff4a25"
    sha256 cellar: :any_skip_relocation, sonoma:        "de1ef581df46f4cdc87934eacc457c0fea934a4ce200b9b4ec564fbd025b1f6f"
    sha256 cellar: :any_skip_relocation, ventura:       "de1ef581df46f4cdc87934eacc457c0fea934a4ce200b9b4ec564fbd025b1f6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bda465094ed8e540c294a3e785e59302390a0dd79bb9bb1d071c33024b7aaaa"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:), "./cmd/docker-machine"

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
    assert_match version.to_s, shell_output(bin/"docker-machine --version")
  end
end
