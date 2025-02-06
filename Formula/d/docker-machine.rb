class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.32/docker-machine-v0.16.2-gitlab.32.tar.bz2"
  version "0.16.2-gitlab.32"
  sha256 "c2036dd04154c08a59e241b20f4d792a356b2723d7c7669dc4ca7c902dbaac4c"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8b693462f057fbe538f4f01cb413d200ef27a33e91f600c7b7fa0f08e12f4c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8b693462f057fbe538f4f01cb413d200ef27a33e91f600c7b7fa0f08e12f4c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8b693462f057fbe538f4f01cb413d200ef27a33e91f600c7b7fa0f08e12f4c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ad04051f35caee93cef6cf582f47bf1d50f8a576f95a638766dc1990d1c079e"
    sha256 cellar: :any_skip_relocation, ventura:       "7ad04051f35caee93cef6cf582f47bf1d50f8a576f95a638766dc1990d1c079e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2f92ef73f77365d743fda7745cc4fa18726dcf01c7ac06f84660ae37beac8a0"
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
