class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.28/docker-machine-v0.16.2-gitlab.28.tar.bz2"
  version "0.16.2-gitlab.28"
  sha256 "95c5041e5e28c942164d515d4327b8ea82b7ae1830185a5013c1c6c41a4e44c0"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9fcdacb25e99d16093d939a0edc652f4654d3ba71fbd7d6f388b2a3eca5003af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85b3ad542a8923113f346ca1dc1fbde659eb554fa06e7b76ebe81243c321cf61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a2f1883dfe7bb2a571e0f1b7e321998e1d9c2f20cef4aa8c6a619369449aada"
    sha256 cellar: :any_skip_relocation, sonoma:         "066bedbb30327f0e191f10889b230b1feea2bbc7cb5fd3b10ab77fc7c205e7c1"
    sha256 cellar: :any_skip_relocation, ventura:        "9373e9800fd5da6c3a5fb9a8ca5ef122bb6003c05067bc5d7a36d4fadfd38cd9"
    sha256 cellar: :any_skip_relocation, monterey:       "57abc0e46687e52f45f5715e82d8bda5c1bac7b6ebde1e73c19affd47e9fe644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b90cacd518287b94dfb8582a340ab21a1a694343c7210772cf9f19c8e4c349f8"
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
