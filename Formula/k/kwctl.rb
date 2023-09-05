class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kwctl/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "f4573ae5c9de7b33d309364cbe479869e2b663c545b15f08420a909fff2169b8"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8eb0a2cf8d73f0eb62c3b200a69a973847649e511f867683751b15a64c72778b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbfd4073968f69ca4977b57bebb8d1698bd32d63a80a607cf72a225b559ea5a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4601892d82f2380399e3881c59c3947bb7432927ec207ea423f038dc21c7449"
    sha256 cellar: :any_skip_relocation, ventura:        "b9ede68d60d77040d8852c1c5f08fe0e6745574a619cf64dc142fbac310de4ed"
    sha256 cellar: :any_skip_relocation, monterey:       "d7dc61052fd4f1e7d44f602d0dbc631099640aeccf0ef7fff92fe4c5436d9477"
    sha256 cellar: :any_skip_relocation, big_sur:        "f852fb01f0c2c5038532a3dffe0984b8b6ccbdf2a36909d895e1b59acf13740b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2062b64f2119f85af8fbbbe85513bd006f92dee648ec9ab9be2c1129a223eebb"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

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
