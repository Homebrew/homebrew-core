class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.96.tar.gz"
  sha256 "26aa29e3fa680ac9df8e30ee89533da1ed322ffa7da8182c909a15ee2b6ad5af"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a1c2c62681986cab086fdf0e60c847c4e6ddf0abac2c7637343a565c26d64e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a1c2c62681986cab086fdf0e60c847c4e6ddf0abac2c7637343a565c26d64e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a1c2c62681986cab086fdf0e60c847c4e6ddf0abac2c7637343a565c26d64e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b7844507e26628e0252ae4c1b00f502113da3ed6afd6260831bc0944d66dc48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c96e4cf7d4405fcdaf2b0da55d102e627a6a5797bc537e064f79d32b180b7dc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8006254468590326cd7899fa17837cc78782b241a377a9a1708bd808c1f9d7b1"
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
    assert_match "Version: #{version}", shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end
