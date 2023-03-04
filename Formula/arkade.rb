class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.9.3",
      revision: "464c8b29b336d5ccadd8685652b4e0d4b33ca3bf"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c4de784a419b0b100e3e6ccba721a2467e0331d5345a91477d7f2f999fe3437"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c4de784a419b0b100e3e6ccba721a2467e0331d5345a91477d7f2f999fe3437"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c4de784a419b0b100e3e6ccba721a2467e0331d5345a91477d7f2f999fe3437"
    sha256 cellar: :any_skip_relocation, ventura:        "0770408ab1ca26555e0c3a1e3ef00e18212ab9f4bc4ce0f332cc6ce788c28e3f"
    sha256 cellar: :any_skip_relocation, monterey:       "0770408ab1ca26555e0c3a1e3ef00e18212ab9f4bc4ce0f332cc6ce788c28e3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0770408ab1ca26555e0c3a1e3ef00e18212ab9f4bc4ce0f332cc6ce788c28e3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fbe9b01de7129cf791bb0cff714fb89fdb7fd8770a5753325a370f9d0dc469c"
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
