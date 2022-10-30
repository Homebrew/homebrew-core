class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.50",
      revision: "238a5fc390147e6658bd8d1562f257dfedf88f43"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0876158894783b08edecb7010bfef58420c5b4889858ca7ebc972ede4c5b8613"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68f3792b7716d31c5474c90751ea28cbcf277ee6c19a5d973ec0fc60272036a1"
    sha256 cellar: :any_skip_relocation, monterey:       "af9f0cefbd784f22c7b7402b32ca4b0623bf9d983261009cba7529b66b21559c"
    sha256 cellar: :any_skip_relocation, big_sur:        "873048d40653c65c5637d3ad66d4e217d7492d9a1abe617002a15f677ca4c6be"
    sha256 cellar: :any_skip_relocation, catalina:       "e57a48f4c839a20e772f8e744580b2eabb77ab244b9ad48337dcdd0de05139c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b93f11d14739a5847aeb369cd2480eede1443ff25daa371cc234f9c06fb645d3"
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
