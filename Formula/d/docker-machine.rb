class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.42/docker-machine-v0.16.2-gitlab.42.tar.bz2"
  version "0.16.2-gitlab.42"
  sha256 "d4589bad573dbfaefbc72965f3fbdef686dc5aa3df388800f0ef98f6c84fbc79"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a21920e3f403d5d982fee93d4b5d4f9e5979b3640c5a1662f60baa55cc07d8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a21920e3f403d5d982fee93d4b5d4f9e5979b3640c5a1662f60baa55cc07d8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a21920e3f403d5d982fee93d4b5d4f9e5979b3640c5a1662f60baa55cc07d8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f1d5cf19ac0ce993fbe5a0a6ebc318956255d37ba286c994612873a686d2330"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0f81fb5ae7314f8fc762217a564c443011174ef6f3100dcc64c6349288cf9dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34a0b95a12e75b2a02a5ec0bdc995258874a015b3e8830cd8a36f9d7843ca483"
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
