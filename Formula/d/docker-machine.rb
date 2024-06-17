class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.26/docker-machine-v0.16.2-gitlab.26.tar.bz2"
  version "0.16.2-gitlab.26"
  sha256 "e8cbea33d013811c13bf80d67da3e2633ebe537047c0f159b3921aa4f502fb0c"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d887659090bbabd723d8d521e81d9e2d1f191d7a8960e209ed5ccfd288f15d0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8814d1ef8e36f1580833ee857382b0714877fdb5caf91ea039c3cb71c1ecb750"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4bc469f85d306094e92a6d5ac029f0c7a181c3ceada37ab2fa2d6205e28d475"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d337a81ad0aa385fa3de26743873e13b6f95bc8a8211c36bb7e6011ea032dff"
    sha256 cellar: :any_skip_relocation, ventura:        "42adf46d08af050bbcc0b42b517ac130dad99f64f12ea09936b1053cf5ff986e"
    sha256 cellar: :any_skip_relocation, monterey:       "858e04b98832e74933cb1144243dde49631884f30ed92c9457f9922734f034ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cca7e62abc04dafc2317489cc582e778ec09ace9f4b779189e9062fb0f6ba47"
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
