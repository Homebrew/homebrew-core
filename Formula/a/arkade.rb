class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.12.1.tar.gz"
  sha256 "bc05e6afe19aa7d2cc15ede42624d0379a5a98aaa30d63e4f98f7ad1457b6738"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ec63bb818d25e96d4111424d65082a5e0bbbd4b5d9f292732864aa5b721cbedd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ec63bb818d25e96d4111424d65082a5e0bbbd4b5d9f292732864aa5b721cbedd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ec63bb818d25e96d4111424d65082a5e0bbbd4b5d9f292732864aa5b721cbedd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "18597187169509ced7b37051774434928bf14c530813bfb1d65025a53d551a44"
    sha256 cellar: :any,                 x86_64_linux:      "1fb2142a10e714809a757817adab55cc19745892dab32aa405d6c858fae55d8a"
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
