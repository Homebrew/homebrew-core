class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine/-/archive/v0.16.2-gitlab.25/docker-machine-v0.16.2-gitlab.25.tar.bz2"
  version "0.16.2-gitlab.25"
  sha256 "a4b7f3f68891206acd3e75bd55ed3b32d92926fd525ca11a85a73612ced308b3"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8f02c44567cd932a4476fd2d551c012c2fbb5a911dd52ad11c55d937f4b3d5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db48e2eb63201e9cd7ef2565788d23e5bcbab0c18c2f8eb9b395d91b60540bbb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f317831b155dcf621a7d4fa4c1bbda790b5277d02a1196b506c3a53523dfb7bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b8d1531f12a01eeee1bc0a9205b1705c2aaf251c258ea791bd2eeb0b8bd3cd0"
    sha256 cellar: :any_skip_relocation, ventura:        "e926d4bdd5b681ad72f6e5bb3f0ed7eac596d8e8216b3776b852c357d24a722e"
    sha256 cellar: :any_skip_relocation, monterey:       "e535c5d86b72d45158f58d4c6abafcfde4b36dd33213bc7b5149152be9b25347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "095a0ec6ca21ffe4be78f5f03ddb89a3e6f191adc821ca2fb5f6d32892468fa4"
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
