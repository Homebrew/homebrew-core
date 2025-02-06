class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kwctl/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "265baff8810d8247c3d4294632f1c13a1d317f7fb912596734b960498fcaa1c0"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e05a0ab667e90a65b6143fc2bbe28800d6fd604944b1f27678d045fb5f9e8f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc68b3f38525c337152167b62622bbe3aa66d323c42a11419f8192ee83ede01f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9bf8458763ccbc956b7ad13b4791541b23af4e3afe91a442965cf830ff133b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "28ee243e17a491005cbeb6213f44fa9cad8c223b5e29cb5e80cca59d4a085ae4"
    sha256 cellar: :any_skip_relocation, ventura:       "4a8a6f9934c9186654934e10a7745871196b7ed8672c7e9f35382c0f5e5a7393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fcf99a6c5184d6ee8930b17ac4ee1d5f8159bdca8bf81426fb008506362edec"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"kwctl", "completions", "--shell")
  end

  test do
    test_policy = "ghcr.io/kubewarden/policies/safe-labels:v0.1.7"
    assert_equal "kwctl #{version}", shell_output("#{bin}/kwctl --version").strip.split("\n")[0]
    system bin/"kwctl", "pull", test_policy
    assert_match test_policy, shell_output("#{bin}/kwctl policies")

    (testpath/"ingress.json").write <<~JSON
      {
        "uid": "1299d386-525b-4032-98ae-1949f69f9cfc",
        "kind": {
          "group": "networking.k8s.io",
          "kind": "Ingress",
          "version": "v1"
        },
        "resource": {
          "group": "networking.k8s.io",
          "version": "v1",
          "resource": "ingresses"
        },
        "name": "foobar",
        "operation": "CREATE",
        "userInfo": {
          "username": "kubernetes-admin",
          "groups": [
            "system:masters",
            "system:authenticated"
          ]
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
    JSON
    (testpath/"policy-settings.json").write <<~JSON
      {
        "denied_labels": [
          "owner"
        ]
      }
    JSON

    output = shell_output(
      "#{bin}/kwctl run " \
      "registry://#{test_policy} " \
      "--request-path #{testpath}/ingress.json " \
      "--settings-path #{testpath}/policy-settings.json",
    )
    assert_match "The following labels are denied: owner", output
  end
end
