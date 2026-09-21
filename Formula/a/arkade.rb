class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.126.tar.gz"
  sha256 "53693acc51c48d23f199c1447973f0710976aa44e97b0a46d7123fd47213158b"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a8bd43f0f88079b5525fab7e0eb15c14db5a3273f5924a5596e4acf17d126bf1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a7d4a55d411e37d9aaf01aaa695247ae2884d1d1dea20647120b267e0b3b9b94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a7d4a55d411e37d9aaf01aaa695247ae2884d1d1dea20647120b267e0b3b9b94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "a7d4a55d411e37d9aaf01aaa695247ae2884d1d1dea20647120b267e0b3b9b94"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fea41f3504dd65808c57e03c3271e1c2f973de6998cf97bd488b4aa52f7333c0"
    sha256 cellar: :any,                 x86_64_linux:      "11f89ed69752db63d5833d7794ccd0338d24b3187dfbb7a7ef6015b8e990a73b"
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
