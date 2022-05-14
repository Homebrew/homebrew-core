class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/armosec/kubescape"
  url "https://github.com/armosec/kubescape/archive/v2.0.154.tar.gz"
  sha256 "4aee9971ebf2ffd6808ee2991b38393e52331ce5f0706060e824ed215046437b"
  license "Apache-2.0"
  head "https://github.com/armosec/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f50fd1d8c2c065c3e4ba02a5091fe72a90e0ba324f4633dfb531855491fac86f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e3cb7c4c1036960771aaf5484293ed78f9a5afcfa5da241fe3f816eb40f0798"
    sha256 cellar: :any_skip_relocation, monterey:       "3ec26d55f5a99a018c8f906929598a0a369396e1bdae054e5a8884395c9381a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "33b9d0253f9021e6d6ee254046c0e83bd32bb42e876f97f9070924f6265cfa58"
    sha256 cellar: :any_skip_relocation, catalina:       "beb549c3d7653c05fdccdd4f72b7ea56284ceb64fae6bfb450a59ec30e97bff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c9e22108ce425cdca3cc21fd01cec3754c5e578e629c12d349a8b70df51d9d4"
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
    manifest = "https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/b8fe8900ca1da10c85c9a203d9832b2ee33cc85f/release/kubernetes-manifests.yaml"
    assert_match "FAILED RESOURCES", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
