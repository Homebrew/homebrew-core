class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.9.19",
      revision: "f497d2e645f66376c1d85000884f14bce953003b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1062d743e5765a86b096131688ae59463ad6d420c3d2dfdddd2b52299c27040d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1062d743e5765a86b096131688ae59463ad6d420c3d2dfdddd2b52299c27040d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1062d743e5765a86b096131688ae59463ad6d420c3d2dfdddd2b52299c27040d"
    sha256 cellar: :any_skip_relocation, ventura:        "9364328387850cc195d14f817a05f0b8b275329366df62d58befe3212182e2fc"
    sha256 cellar: :any_skip_relocation, monterey:       "9364328387850cc195d14f817a05f0b8b275329366df62d58befe3212182e2fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "9364328387850cc195d14f817a05f0b8b275329366df62d58befe3212182e2fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36ba66b718b947fb1ebd176ccce616bb06c039761f22cd4536862b139c3866e0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{Utils.git_head}
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
