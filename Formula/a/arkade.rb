class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.16.tar.gz"
  sha256 "aec300681c8568c62461800cb0f17a49947baa34da1c7525ceb8b438d8c2a523"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65ef665dab3b6fddb3d61a300b2df6fac845b22d8798db2f3b4b365fdebf457c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72fbd46c431d09aa7e506afa7690a202bc6c2155619790363ecb460eb56125f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ddd36bd52a5732aed3fc450d43e29c349310d384154c4b623fea7c974352377"
    sha256 cellar: :any_skip_relocation, sonoma:         "572468910fb4648d8b68579bb0dc239ee908585a1aebde7ef8664233a87e4be2"
    sha256 cellar: :any_skip_relocation, ventura:        "18aae532770a8c043627267b38fc9748d7bf1cb4c4c73c5b2c580f0c59f91fb0"
    sha256 cellar: :any_skip_relocation, monterey:       "603be8209bb25f5e1e7dac713979470b60fff2a711e01af0bd8ea30bd9c835ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a3a8be4074f3ecd133fd219e26e0447f3a14fc153531da60b12fd4502fe838e"
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
