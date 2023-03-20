class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.21.1.tar.gz"
  sha256 "d59f5a3ab34b6196570a5ad011869f94d6bf68540f85f177e3be66196ad92496"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "323d8e600a26f3128b5414e93b09ee9306d37568ddf330ab55e4a477a866dabd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f8b8454457bdcd03b06931361df192b1444700b44e720ed9d8e689c20f05480"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41c65487ed6fff96d892842bc9d4f377352e0d0f7baef128c59de6561fbdc9b2"
    sha256 cellar: :any_skip_relocation, ventura:        "03fc31b451fce5a6c6dc84b245235d3b46151f9d60fb8f7225c8d13955a26f23"
    sha256 cellar: :any_skip_relocation, monterey:       "dfc601b2c7fc93a3f6df18f6557383af494b668c87fd49050d2ad1d032218da6"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7566e731a32917288ac31cafa191ae72062d08ec8c5559b22685120e9dd388d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98000ac8c905a7525afb291f5b2a14cabd325823ea72d8087a9656e042723083"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubecm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end
