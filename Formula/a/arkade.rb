class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.11.4",
      revision: "7aefb132a1dc703a6a895cd75c12deb6775459e2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63be049ff5064b591fa41b738103e1458cd9123e66b2440823b51cbd4052ce28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1eb0938a8ee6b618f841b97635f7c9d73971faaefc11de7703b2b943bb44aedc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f92674189f583ff69fe96b638f3d5c768185fd3e9b28e428c46529cca0c5e29"
    sha256 cellar: :any_skip_relocation, sonoma:         "05b4d78790e3cd5df7b1b825e5c3477340e8545d1bbc066b9da232fa569a19f9"
    sha256 cellar: :any_skip_relocation, ventura:        "27535a9fd29f219c83e6600834e2b7a3cef0f6e69870944511ce1ee148ac65d2"
    sha256 cellar: :any_skip_relocation, monterey:       "2cb4a82634963c1fe09338a0915fa7240bcc399615f11f43223374c114dd6fc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d34f73ee0dea2f0b7d58cdd1325a7d9aa8d362c8048626ad3cc032aa1a18765"
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
