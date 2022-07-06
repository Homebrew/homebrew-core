class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/armosec/kubescape"
  url "https://github.com/armosec/kubescape/archive/v2.0.161.tar.gz"
  sha256 "165222d24db46b70a664fd70e8918f478c39c05ef30bbcbfb57c05307d88ce6a"
  license "Apache-2.0"
  head "https://github.com/armosec/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9d9b28680a8e959f8e45e76a136387f489361622f340653f9566c699245ceb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "469562f4aa22bfc04191ec45ab9a36ec53dde5eb6eb4a5c79d103fb167f074dd"
    sha256 cellar: :any_skip_relocation, monterey:       "86380b99d0f86cb8999005c1f7c599e6ea89cba14588628032c0e0c26fc0b1a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "67eda866ca3f851186ee8b5290e065164e9d273c17c40327131580306ad1e01e"
    sha256 cellar: :any_skip_relocation, catalina:       "d1d1ae670a80508f4840c9c8759a0d7b748e03ae2b4e2c15ccabd3c3c6eaffa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b780db3d202b2734a00bf3b2e36663571393c0fdeef19696ac25985b9c53ac40"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/armosec/kubescape/v2/core/cautils.BuildNumber=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    output = Utils.safe_popen_read(bin/"kubescape", "completion", "bash")
    (bash_completion/"kubescape").write output
    output = Utils.safe_popen_read(bin/"kubescape", "completion", "zsh")
    (zsh_completion/"_kubescape").write output
    output = Utils.safe_popen_read(bin/"kubescape", "completion", "fish")
    (fish_completion/"kubescape.fish").write output
  end

  test do
    manifest = "https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "FAILED RESOURCES", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
