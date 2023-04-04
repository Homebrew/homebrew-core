class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.9.8",
      revision: "f904a2e70d860477be02063161b1eac0ab2474ef"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bf898d6e68eaa1583f3a95757f68c8f8aa9e5a24f0e3b5f60d07b448b6dce84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bf898d6e68eaa1583f3a95757f68c8f8aa9e5a24f0e3b5f60d07b448b6dce84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bf898d6e68eaa1583f3a95757f68c8f8aa9e5a24f0e3b5f60d07b448b6dce84"
    sha256 cellar: :any_skip_relocation, ventura:        "2cd907b68bf8492fbc36960e226f9e3b8c0faa740fea960df0abb3b975b0232c"
    sha256 cellar: :any_skip_relocation, monterey:       "2cd907b68bf8492fbc36960e226f9e3b8c0faa740fea960df0abb3b975b0232c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cd907b68bf8492fbc36960e226f9e3b8c0faa740fea960df0abb3b975b0232c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98c0b5482f989364934ac18a4aa251d42df7dbdad1c8dac5b10c1d120da4318d"
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
