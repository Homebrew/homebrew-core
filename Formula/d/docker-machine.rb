class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.29/docker-machine-v0.16.2-gitlab.29.tar.bz2"
  version "0.16.2-gitlab.29"
  sha256 "e387387fb5cab607b6214fb7d08f1e0b39f501195a92ba85879b924f4504a2e3"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42890fcc319f76dc5694b6ffb6dd30a5b9a710bceecb5be0770f5be3c30c24dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42890fcc319f76dc5694b6ffb6dd30a5b9a710bceecb5be0770f5be3c30c24dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42890fcc319f76dc5694b6ffb6dd30a5b9a710bceecb5be0770f5be3c30c24dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc5474070d4d78c4031091d66f1609294f68bd126d5bef2899513c4b610ec011"
    sha256 cellar: :any_skip_relocation, ventura:       "bc5474070d4d78c4031091d66f1609294f68bd126d5bef2899513c4b610ec011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63ec4e9e6d0f3b504166e5993d6a5dd3f7819840dfa71fb37cd2a03d2f0d9663"
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
