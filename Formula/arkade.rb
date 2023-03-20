class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.9.4",
      revision: "eef3feffaf145b4bd6e2b3fec8ba6c707aed1476"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f82220a4d994ba7541c7658ddf56b67ddefc2f3e93317d8e9d4d230b77b46715"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f82220a4d994ba7541c7658ddf56b67ddefc2f3e93317d8e9d4d230b77b46715"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f82220a4d994ba7541c7658ddf56b67ddefc2f3e93317d8e9d4d230b77b46715"
    sha256 cellar: :any_skip_relocation, ventura:        "626e128f1c8bb7d5ecf50b208c23f1af71e94bac4e58424c710b00f4cbabeac4"
    sha256 cellar: :any_skip_relocation, monterey:       "626e128f1c8bb7d5ecf50b208c23f1af71e94bac4e58424c710b00f4cbabeac4"
    sha256 cellar: :any_skip_relocation, big_sur:        "626e128f1c8bb7d5ecf50b208c23f1af71e94bac4e58424c710b00f4cbabeac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f483fda749823c7fd1d95b85a11ca0778d0a5e6c635985d3d9a480b6fd7324a1"
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
