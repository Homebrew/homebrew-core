class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/armosec/kubescape"
  url "https://github.com/armosec/kubescape/archive/v2.0.153.tar.gz"
  sha256 "2dd96ca4d78789c75491fb4babcbd2848bf134ad22426eeb84f305316b28ce84"
  license "Apache-2.0"
  head "https://github.com/armosec/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8ec324044c0357190e7e4053968943bbece632565e6b8139d74876d94b9586a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bdd5c937f256073aef48b34f70bcfc77abccb218c0dba1ea7cb0b2c86a9647f"
    sha256 cellar: :any_skip_relocation, monterey:       "f2d86670c4eb554a345533028a2905b5fb4d34d8311b172e5b703caa45abe397"
    sha256 cellar: :any_skip_relocation, big_sur:        "0411dcf57b992c6c763d0f07e1346b34bd0d651698736c49b88ec3104be1a4a0"
    sha256 cellar: :any_skip_relocation, catalina:       "631f6a520f21324c8bac9d31ef27fd4856b8930d77fb895b31da5f0773e742e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6993b2d9d6dc8157f040f45bbc969ba34d2290667ac01d103ddd4a974fa49b56"
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
