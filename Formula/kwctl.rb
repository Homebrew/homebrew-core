class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kwctl/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "e04e75063689e73a386e841987307d473520a8f9834acf8d08434cc6cc688d60"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9c2c796d3c25ba33d6c8f907a1755dbd639f31e51dd83268c5efc91aca3d4a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea8e61cbf57feb4fab235d78dc4ad629babb58a6e277bfc27c6e5e7ce9dce2ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32d2ee30a7ee663fd8ab7809016e7c4b1c6ae41526e185f41a7591f4804d2457"
    sha256 cellar: :any_skip_relocation, ventura:        "4078c8caaa3aa2388465ef1bd2cf084e8e3f771f2e5e0a8b9d0200f67dcea492"
    sha256 cellar: :any_skip_relocation, monterey:       "5f431513a9fee9aa40302909df7f653be7ceb9427eb78e303e74f6d26da7c2b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "cebc85df660e2624ff4353764c181d4b2a96c8c320261af889d0024ad0447728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd435cefc90b9ef6eaf66f05e9fbf9f669e54a851e57731c62172920f708ce01"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_policy = "ghcr.io/kubewarden/policies/safe-labels:v0.1.7"
    assert_equal "kwctl #{version}", shell_output("#{bin}/kwctl --version").strip.split("\n")[0]
    system "#{bin}/kwctl", "pull", test_policy
    assert_match test_policy, shell_output("#{bin}/kwctl policies")

    (testpath/"ingress.json").write <<~EOS
      {
        "uid": "1299d386-525b-4032-98ae-1949f69f9cfc",
        "kind": {
          "group": "networking.k8s.io",
          "kind": "Ingress",
          "version": "v1"
        },
        "object": {
          "apiVersion": "networking.k8s.io/v1",
          "kind": "Ingress",
          "metadata": {
            "name": "tls-example-ingress",
            "labels": {
              "owner": "team"
            }
          },
          "spec": {
          }
        }
      }
    EOS
    (testpath/"policy-settings.json").write <<~EOS
      {
        "denied_labels": [
          "owner"
        ]
      }
    EOS

    output = shell_output(
      "#{bin}/kwctl run " \
      "registry://#{test_policy} " \
      "--request-path #{testpath}/ingress.json " \
      "--settings-path #{testpath}/policy-settings.json",
    )
    assert_match "The following labels are denied: owner", output
  end
end
