class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.12.0.tar.gz"
  sha256 "f3c902c7880a7063bcce063b8435462c70d541043abd0fcc917a5713c015a564"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9c5cc6ebb0acffe0acd0f8308ceb2f0a4237b6f52d451a37760cc87d78514e25"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9c5cc6ebb0acffe0acd0f8308ceb2f0a4237b6f52d451a37760cc87d78514e25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9c5cc6ebb0acffe0acd0f8308ceb2f0a4237b6f52d451a37760cc87d78514e25"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fa732bde6c3b8fe196b7a022c09260832506ed83a684547416c441af7d04b577"
    sha256 cellar: :any,                 x86_64_linux:      "617f1d5dd07ac006ced82315969e375da6204f8aff01682742b4a65fbe2112c9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
