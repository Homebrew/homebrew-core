class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.2.6",
      revision: "db7d90a1f609685cfda73644155854b06fa5d28b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63c5b8e469f499968af9bd3d0d7b09e9b3f4917f24c6856b2915dbd9c58517b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ce7e347ef3d6366cdc9b64a843e5c11898e050aea0b9c89617b214f3ff35aab"
    sha256 cellar: :any_skip_relocation, monterey:       "47d826037995bd4cde14c3a7fdc00a92cd112a7e0f7945a57aae1f71437c6f9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9af639de2185ab11c49496a6b4679558032ecb15bb713db77970aa8acb0693d"
    sha256 cellar: :any_skip_relocation, catalina:       "3cf15a55c4b8e01184f7ad877d415391cfb88f74c76a44a68922fcd7e87ff1e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d1ef81ce88e8b91df0ad120ec2de1743dd5820883afcaae6dc33c5c28f638f8"
  end

  depends_on "go" => :build
  depends_on "node@14" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "dist/argo"
    bin.install "dist/argo"

    output = Utils.safe_popen_read("#{bin}/argo", "completion", "bash")
    (bash_completion/"argo").write output
    output = Utils.safe_popen_read("#{bin}/argo", "completion", "zsh")
    (zsh_completion/"_argo").write output
  end

  test do
    assert_match "argo:",
      shell_output("#{bin}/argo version")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig ./kubeconfig 2>&1", 1)
  end
end
