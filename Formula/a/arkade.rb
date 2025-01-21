class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.32.tar.gz"
  sha256 "4f230cd9f07d9965ebd495f9040e194811a4084fe0cac55ad2bac7939d24f393"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8b26808b966619cdd8275dca138db7ac2752f655167d455cd64b5dcb0314fe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8b26808b966619cdd8275dca138db7ac2752f655167d455cd64b5dcb0314fe4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8b26808b966619cdd8275dca138db7ac2752f655167d455cd64b5dcb0314fe4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0316c04f33b30da630f068a828188a3ad4ec7572f6ffb7132e7b08b2e9a2f247"
    sha256 cellar: :any_skip_relocation, ventura:       "0316c04f33b30da630f068a828188a3ad4ec7572f6ffb7132e7b08b2e9a2f247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b75417dd0c21935f25939e10ab01c6b26a63ec7ef01137daa3cc8b7c2951c65f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

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
