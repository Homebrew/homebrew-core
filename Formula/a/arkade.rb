class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.109.tar.gz"
  sha256 "2c703bec03c962adc7e89caebe40450a9d6e015e9f3d7001ecf001f427411595"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0eef84d2510df59c8224a6531eb11d3baa927af667e181c8ebc83199c66271c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0eef84d2510df59c8224a6531eb11d3baa927af667e181c8ebc83199c66271c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0eef84d2510df59c8224a6531eb11d3baa927af667e181c8ebc83199c66271c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7cc5360261b81e4f229e97ede9b7694ba267da77e793e0fbf0c7249e05376f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9827761b50569b2c694f758723acb4c50e1575fba1f6b3bcf16dd112d1481cfb"
    sha256 cellar: :any,                 x86_64_linux:  "b89eb06a83f7c2973f15f807394d22eed6a6d4c3cf1752ff5e3e4fdb5a5b0a77"
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
