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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e2583d46870f7cfad9c8f0925c9e31ffc77e98b1afe65a2277fa42eb7f95904"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6fbdffff3171bfb983293048916e9c70a0dbf29c278136f984a4e50a0f3a796a"
    sha256 cellar: :any_skip_relocation, monterey:       "e70edf0fe2e61e309e87ea1782b8d4e805554bf9b4d83627978786accdbf386a"
    sha256 cellar: :any_skip_relocation, big_sur:        "26f67ba92a83d7e15b9c4d18ec080a29faca350b60188d06a8b4a3af77b8d203"
    sha256 cellar: :any_skip_relocation, catalina:       "9da5b7cc7425ccc5d73f8636c25630fbd2ef7825038f183aa3c5be9c5f1a227d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13fe79c13f1968a6ee51d3b4dfa0c7a67d41175197690d041078daa76aaa2160"
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
