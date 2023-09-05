class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.10.0",
      revision: "8965ff8b7bdfc6f23543d509cc1e6774c37a9fe6"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64044af792734f2a95a5c733bcefdc51636b288688fad83161cb9cc74357b678"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d84cdae443b7af8a94f5673b60338682e0bf39dbe87c01c72ba023ebb5b0e4c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06d5c14d1620044e66da57d93d7ec766da700b37acbc9e6df441a6243d54c854"
    sha256 cellar: :any_skip_relocation, ventura:        "7b8ff551de6f1f154d8ab6958a354e1fb32f9071d2941487a7129730ac302e59"
    sha256 cellar: :any_skip_relocation, monterey:       "39a020fea79d7b68f5498ab0c99eac714aae87ec131203aef60f9b544c128d6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee59a010f1c69a2c3ec1d08010060875fafe50fa7a7f9a3a17025142f177916c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c3db2bcff2ddc2fc2f72d942194f177b7ebb5b9e234df2553a7c1b4212e0eac"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

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
