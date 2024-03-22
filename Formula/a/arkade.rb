class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.11.6",
      revision: "acb1bd999ac81840fbbe49f3d1cc1fbd386f7fd4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75ef9333676da22eac0d3298efc54770b2c0811fc9734d752bbe7015dad39132"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "536d60f2a67c46c8ed1eec0f1f6280405ae4237672f06d30860f4d5e3bb645b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bddce7d3778f263df0c00e979d251a4704fc02365bb14f7538d334f2165ef93"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c57ad3dd6dfc304d31006cadb3b9ab2d2d02be335a35d6d373b6ae812e7078a"
    sha256 cellar: :any_skip_relocation, ventura:        "de796e48c27d53fd87d98199baa43f0e9a8770d612d717dad75b6e68a3e3eb0a"
    sha256 cellar: :any_skip_relocation, monterey:       "9840d4abe143f19f96f55081cf2d3eb89c325f9acc47d7e4ef4b5cd0e9564e77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53eeafbe7a7275ed0926448f1e1997203e01bf175b4ae47e6c4fda3c00a0d24c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{Utils.git_head}
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
