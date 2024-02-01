class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git",
      tag:      "v0.16.2-gitlab.24",
      revision: "38385069d7f23410d434dc35a3c209b7a8beb0c3"
  version "0.16.2-gitlab.24"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cb251929d0b164418fbab2bbb6a76836b8dfee37823cb008d680f5fbfff145d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38b4bc24bf04af27e03e11021febc42af27300bd345952ec63b59e057e2495f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f80d55b6c43025745166ebb7d6dfec9b0a0c3539c47b284b912252c9fe5dce3"
    sha256 cellar: :any_skip_relocation, sonoma:         "570779e7df9702b3b0ee9e4bb325868164e734a1f6cf479a5e283fff1abf5e7d"
    sha256 cellar: :any_skip_relocation, ventura:        "27afe8031ab01ccc35eb62465bbe30ecacb0bce05d30d08604b3128a186971cc"
    sha256 cellar: :any_skip_relocation, monterey:       "a84963d45669cf7af168963e171ec3227ebe9751a0cae286e380011412c52f44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98dc3c6b44ecb7242954b862fd54154177629a03802bd2c8df7c39f68fe0d57d"
  end

  depends_on "automake" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/docker/machine").install buildpath.children
    cd "src/github.com/docker/machine" do
      system "make", "build"
      bin.install Dir["bin/*"]
      bash_completion.install Dir["contrib/completion/bash/*.bash"]
      zsh_completion.install "contrib/completion/zsh/_docker-machine"
      prefix.install_metafiles
    end
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
