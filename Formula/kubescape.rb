class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://www.armosec.io/armo-kubescape"
  url "https://github.com/armosec/kubescape/archive/refs/tags/v1.0.109.tar.gz"
  sha256 "6527e688b62188679d52a79befd3e77cc13801b87db419963e06d85a3a502bcd"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/armosec/kubescape/cmd.BuildNumber=v#{version}
      -X github.com/armosec/kubescape/cautils/getter.ArmoBEURL=api.armo.cloud
      -X github.com/armosec/kubescape/cautils/getter.ArmoERURL=report.armo.cloud
      -X github.com/armosec/kubescape/cautils/getter.ArmoFEURL=portal.armo.cloud
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags)

    output = Utils.safe_popen_read(bin/"kubescape", "completion", "bash")
    (bash_completion/"kubescape").write output
    output = Utils.safe_popen_read(bin/"kubescape", "completion", "zsh")
    (zsh_completion/"_kubescape").write output
    output = Utils.safe_popen_read(bin/"kubescape", "completion", "fish")
    (fish_completion/"kubescape").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubescape version")

    manifest = "https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/master/release/kubernetes-manifests.yaml"
    assert_match "FAILED RESOURCES", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")
  end
end
