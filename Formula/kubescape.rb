class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/armosec/kubescape"
  url "https://github.com/armosec/kubescape/archive/v2.0.160.tar.gz"
  sha256 "b9231436644b84869fe2ddf27e22ebc815c7a43b8202131238cb78fb75baa351"
  license "Apache-2.0"
  head "https://github.com/armosec/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "452de451438bf45c9fcf24f82799fbfd34d459cdaf32a917ba377ef2e6675c72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "341b4910a7d9e9c1603a52b196694a75f0b7bf4f1977c5f37114c18a46729a0d"
    sha256 cellar: :any_skip_relocation, monterey:       "df9e7368b568fbc86ffb4ee154f7ebcb0f9d6b06a0bec085f9d3f2f891a1648c"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb9edc20fd7ada822da3fb0782b8416e370001769040f73bced2d11b7d7b6c62"
    sha256 cellar: :any_skip_relocation, catalina:       "652d134d280d3b7dd2d61f16ee24058924220d128ef634dd152948d89574b7e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0cdcfb1aa07cb1e655af20070b6b0afed3a0c5a89a916967d79ab5352662de1"
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
