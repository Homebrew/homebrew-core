class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.44/docker-machine-v0.16.2-gitlab.44.tar.bz2"
  version "0.16.2-gitlab.44"
  sha256 "10b3032f43f445e3974f2890497a89f41d2e7134a60d507e03394d5f40a8c94d"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "823f450ddacb8084dd02faf2f4b661b04b8ca9675cdf353f2ac11bce6af40135"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "823f450ddacb8084dd02faf2f4b661b04b8ca9675cdf353f2ac11bce6af40135"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "823f450ddacb8084dd02faf2f4b661b04b8ca9675cdf353f2ac11bce6af40135"
    sha256 cellar: :any_skip_relocation, sonoma:        "b726084a3e934e9ac0793deb5b75955ba986690bfa508cf00d3973af4b7e1226"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac743b52ca476a3a87fed051c01bff62d345a2d74926e204f81a93167b24d578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f11b58b6bdca6ffe6682e6b25ded0495c4191d0191f13bfc19b19a9a0a9afd3"
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
