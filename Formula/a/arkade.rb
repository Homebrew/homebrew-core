class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.113.tar.gz"
  sha256 "3adf369bf229709255aa5d4a6ff6c2959f4f2eb678e3b93a4cc4471d19de1f2f"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc7ffcba12e2a8653aee732421f23633c1d43032755fa4e7cc082e1aacd46fff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc7ffcba12e2a8653aee732421f23633c1d43032755fa4e7cc082e1aacd46fff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc7ffcba12e2a8653aee732421f23633c1d43032755fa4e7cc082e1aacd46fff"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cf46a7c213c1df58aaf332ff3027a4b84d58bdf3a709d7e4ffa61cb973a5c63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ac190440840c2021bea36ee6f1d07c382f9a9737949114c026a2d0cc2b84a5e"
    sha256 cellar: :any,                 x86_64_linux:  "e03d3477b4a74fea47b25a8c461a70389400146127a5b4826b08b2d110148470"
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

    generate_completions_from_executable(bin/"arkade", shell_parameter_format: :cobra)
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end
