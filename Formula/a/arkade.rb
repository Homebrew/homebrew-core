class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.20.tar.gz"
  sha256 "3812824a6b7a8e054e819ee08b887ddd2a724b31a8af6464f59c7e52b7b5cfe1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b65a3bf5d8486f0adbc368124782e55eae64898ce110eae61b2f13417ab96504"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b65a3bf5d8486f0adbc368124782e55eae64898ce110eae61b2f13417ab96504"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b65a3bf5d8486f0adbc368124782e55eae64898ce110eae61b2f13417ab96504"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b8d72027d72c888a3d486262f3ba2b95de185659f683741fc4bc821b8d32ded"
    sha256 cellar: :any_skip_relocation, ventura:        "0b8d72027d72c888a3d486262f3ba2b95de185659f683741fc4bc821b8d32ded"
    sha256 cellar: :any_skip_relocation, monterey:       "0b8d72027d72c888a3d486262f3ba2b95de185659f683741fc4bc821b8d32ded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec854499d8fb2ccb2cf62b64746bdc7947cc3de9b01cfc5fcfb20199c3c5e790"
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
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end
