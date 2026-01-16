class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.43/docker-machine-v0.16.2-gitlab.43.tar.bz2"
  version "0.16.2-gitlab.43"
  sha256 "51f983f128fba78cbbf75003481b6de0d56569aa32e40a3c57785814e555ca73"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e01f1d05eeb72197584e2638b48d81abda4bb56fc30c07f658570d44aa742ebd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e01f1d05eeb72197584e2638b48d81abda4bb56fc30c07f658570d44aa742ebd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e01f1d05eeb72197584e2638b48d81abda4bb56fc30c07f658570d44aa742ebd"
    sha256 cellar: :any_skip_relocation, sonoma:        "4753520a680c9076a9166ce193cac7c5152fc910461d38123a24cdd65820433b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2339a698a367390382aef26266a3877a7e7476cd7eabc82bd32b1388e29a8e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a334f3b5108572c0475954e497e40ed2a1fb26a75cab58422aa4079ed41749c3"
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
