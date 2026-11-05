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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "841b2752fdf72941f82257b5ecb82d721ed1f9065cc097a0c60aab91d79f0546"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "841b2752fdf72941f82257b5ecb82d721ed1f9065cc097a0c60aab91d79f0546"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "841b2752fdf72941f82257b5ecb82d721ed1f9065cc097a0c60aab91d79f0546"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c56101880ef2cfe26f8711ecec1b924302f8d79096f69e794eb3614aaecffc57"
    sha256 cellar: :any,                 x86_64_linux:      "985fb5232fe1819e781498b1c12c0a0b30f4eabaabc232f855864f7fc7007961"
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
