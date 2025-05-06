class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.35/docker-machine-v0.16.2-gitlab.35.tar.bz2"
  version "0.16.2-gitlab.35"
  sha256 "eeee9312a0220aca825668b0a05b17c02a061d0a9aff4f966068e981d0ee0271"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e94c4c302ee9c7fca30888e2c46c6065c6349464acbce6aa7febad595171a9ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e94c4c302ee9c7fca30888e2c46c6065c6349464acbce6aa7febad595171a9ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e94c4c302ee9c7fca30888e2c46c6065c6349464acbce6aa7febad595171a9ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f332144a0eab5b87bb059592b91b524dd48cd328a44e4c879a6d4819ae0578c"
    sha256 cellar: :any_skip_relocation, ventura:       "2f332144a0eab5b87bb059592b91b524dd48cd328a44e4c879a6d4819ae0578c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "086a0f5f38b6b6cc496d80582ba42a89fdab4ff94c2ef504f4551b5d5ac4e65e"
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
