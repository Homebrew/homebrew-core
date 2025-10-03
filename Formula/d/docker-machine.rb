class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.gitlab.com/runner/executors/docker_machine.html"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.41/docker-machine-v0.16.2-gitlab.41.tar.bz2"
  version "0.16.2-gitlab.41"
  sha256 "1c8e4b303e49aaf31061657ec68ff85f5bf0559b174ec4d5f358a63c18292a12"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0a454546964b233fbb4fd58385259976707eac429e1df3c24f2b789ccf5b6b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1275c823c9458fbdf5408266b8c6ab6a4848c3fd103d442142a4db5246a8f4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1275c823c9458fbdf5408266b8c6ab6a4848c3fd103d442142a4db5246a8f4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1275c823c9458fbdf5408266b8c6ab6a4848c3fd103d442142a4db5246a8f4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f29bffd32c150b0ad2d8196aa39f6415002bf8fa06d57448592976eaa9dd785"
    sha256 cellar: :any_skip_relocation, ventura:       "7f29bffd32c150b0ad2d8196aa39f6415002bf8fa06d57448592976eaa9dd785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "314a732f0b72cf8f57b5019e64fa5c2afc88440053e169022b8dcde83e25856f"
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
