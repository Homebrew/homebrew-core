class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.9.0",
      revision: "57c87307e2423a85c4515c059c9c0c99ebc3a0ca"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dea9b7ffd69e42e79413be3aeecfe052cb8026b3f63fb409b319d71d07cea829"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa65448301193f11c40368fbc48ffafc993aaafa93be5b4a4b4b461e0f4b6716"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04f3987b07134fca156b4191d01869da26724da68d481ecff72687a5b8f6c787"
    sha256 cellar: :any_skip_relocation, ventura:        "08ebc4d07e5008a136abcfd580296cee1d9aeb78852e2a8ce281edfccff5f7c2"
    sha256 cellar: :any_skip_relocation, monterey:       "b6d143c8d43c041d3ee3c01ca3ee1001b55c7e6b79d72827c931a969c81b0b74"
    sha256 cellar: :any_skip_relocation, big_sur:        "11700e624d45f3fa1051c2cca8647382f6c50e966345d3ebd148ac750820a8db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc92d3eb8cb30446954b0366ef7358fbe43fc1d03faa3388cc895917149ebfc3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/cmd.Version=#{version}
      -X github.com/alexellis/arkade/cmd.GitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end
