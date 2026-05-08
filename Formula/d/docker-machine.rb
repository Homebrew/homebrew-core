class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.46/docker-machine-v0.16.2-gitlab.46.tar.bz2"
  version "0.16.2-gitlab.46"
  sha256 "2d81387323865117315c63c571d254743b9e5472eefc42a1db64fb5f8c33594e"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "daf32b25c976f79c3f73ac246a31e1ce07c973344e7531a60df64ae1a9ab0500"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daf32b25c976f79c3f73ac246a31e1ce07c973344e7531a60df64ae1a9ab0500"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daf32b25c976f79c3f73ac246a31e1ce07c973344e7531a60df64ae1a9ab0500"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6f8fd8a6f3f83bd0cc29f6f5503f866a55b097e269ec1f97baf801dcce32274"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6c5bfe1f4d7f5bc723875f759b983cad83188780c75818c68bd55d35ec58acb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e4afac0b3bfffa6ea13406cc82f666b15a64587306b44edffc8d630366884fc"
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
    assert_match version.to_s, shell_output("#{bin}/docker-machine --version")
  end
end
