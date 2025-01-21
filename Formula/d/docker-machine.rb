class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.31/docker-machine-v0.16.2-gitlab.31.tar.bz2"
  version "0.16.2-gitlab.31"
  sha256 "27f1f4c742debe0455ea2c3f1800a262a95dce14aac1dbd2cd82645d7b7970d9"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a4beb153b0c550f4bd6b40003bb5ba4cd7f5b70e3d95935fecd9c7053fa2049"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a4beb153b0c550f4bd6b40003bb5ba4cd7f5b70e3d95935fecd9c7053fa2049"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a4beb153b0c550f4bd6b40003bb5ba4cd7f5b70e3d95935fecd9c7053fa2049"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d9b287490a70d58ced64b975b8c7281d012ea560deb0817da4697e0ab119922"
    sha256 cellar: :any_skip_relocation, ventura:       "9d9b287490a70d58ced64b975b8c7281d012ea560deb0817da4697e0ab119922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "638e1dfd7391e17f2796c71cc54f0f2fddaaffb9c80acbb487db0a8a53edfbe1"
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
