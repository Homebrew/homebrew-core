class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.11.10",
      revision: "ebceee85141d6f27835f9f2bb3d9151e75546bfc"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4c9e7265f0f9efb50d93b4bdb3168b47ff7686c78294d99b1d5ba667563fd95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f2500715eddc5d63f76fc44f1106b2a18822a8733e97aca05aa4439c0b49a0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74fffd53c97d2615fd91fc084c2b72e90e47d1b55052fac51ab6a0aa85bf82e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "8aeb31a5986243a41111668104fb2d0580a546c2c93902731fc6b0901bcd0e4b"
    sha256 cellar: :any_skip_relocation, ventura:        "fc70a41762f7ca86943ac06949e3c1b0af218cdb87d3dc05cf6793085b1e4a61"
    sha256 cellar: :any_skip_relocation, monterey:       "5a4c2ed67c7130a20386abb0cd73fd5a5b5296a48c4be53a8a69826c4820a8d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e758f834bc7cd98b860933cb75226f4721564d5c618b1032be3b6cf5f50b0aff"
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
