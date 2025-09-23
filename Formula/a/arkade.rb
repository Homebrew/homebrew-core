class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.47.tar.gz"
  sha256 "69ee2b47553e9d745649d8ffc923174007f321c4bba5c7dac3d22c54c3874e7e"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efead7aaebfc75b42ba6aa58458f7ec7b8d403bfd512f73a7db983c276adcb80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efead7aaebfc75b42ba6aa58458f7ec7b8d403bfd512f73a7db983c276adcb80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efead7aaebfc75b42ba6aa58458f7ec7b8d403bfd512f73a7db983c276adcb80"
    sha256 cellar: :any_skip_relocation, sonoma:        "21f23f7e023a4688f250b32c32cf9fa837768f4d60a29441b8ac1baa3de47898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee7fd722f209a9a0da1ca5b68a2fdab67d1167a6f41a686330be05c8f029043c"
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
    assert_match "Version: #{version}", shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end
