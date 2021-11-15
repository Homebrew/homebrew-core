class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine.git",
      tag:      "v0.16.2",
      revision: "bd45ab13d88c32a3dd701485983354514abc41fa"
  license "Apache-2.0"
  head "https://github.com/docker/machine.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c941d688b50d6eae302320aa5e702d5da26e4e38ceac2f925a24b6efe6c589db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ed6a73a1d30c911811e8f6fb0e61e41bc3be4aea62bc2b77f7b6dca50b517a9"
    sha256 cellar: :any_skip_relocation, monterey:       "9132d28324994e3908e2b3e26a5c7f3070dbb0d2061a9e37f6d8b84a76b2cc57"
    sha256 cellar: :any_skip_relocation, big_sur:        "720ea8bbbfdc6b9d0701f02014e09f6a46e6785bcbdb36ebe3e95bddd0849dfa"
    sha256 cellar: :any_skip_relocation, catalina:       "e27501077ccc67fc468ca8e2881366a9fc23260296ed93a3f436b4d12f41ec43"
    sha256 cellar: :any_skip_relocation, mojave:         "0cfe7d344bd6c2b3bc0d1c1de472c430162a45dd54454b268e82750094b9cf9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f08e7ba29eb793a79b8126631485ee4100cf07b9e1e5654a7c4db8c2d229d5af"
  end

  deprecate! date: "2021-09-30", because: :repo_archived

  depends_on "automake" => :build
  depends_on "go" => :build

  conflicts_with "docker-machine-completion", because: "docker-machine already includes completion scripts"

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

  plist_options manual: "docker-machine start"
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
