class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.123.tar.gz"
  sha256 "9de90fda9f6afff8486697c189da9d9ba74d3f2f1ba72ec0a572bc794708a1e8"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c709e94a1e3f924500c00f82057faf5d2e3d186f610381c1eaef816c5b4b561"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c709e94a1e3f924500c00f82057faf5d2e3d186f610381c1eaef816c5b4b561"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c709e94a1e3f924500c00f82057faf5d2e3d186f610381c1eaef816c5b4b561"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc225e8de2bb6681935687384ec6a49ed56dcc3959f12be39c5e97186563ad48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52f8c9096913ea7fe78be6eafe1c0b9bcb8a253a5befd1e5be72998a970e947d"
    sha256 cellar: :any,                 x86_64_linux:  "efb496047907d7f16260f0d8b4a728ebfdebbafc4c3f5828aaf9abfb9200f65a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", shell_parameter_format: :cobra)
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end
