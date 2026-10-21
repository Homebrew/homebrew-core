class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/adm-controller/archive/refs/tags/v1.38.2.tar.gz"
  sha256 "01370d25fc29c7e90d827870652a54c697cb465046946b874e2d8d60a3d5ac8f"
  license "Apache-2.0"
  head "https://github.com/kubewarden/adm-controller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f10ec13208976b2548ae58e1aeeb0c3901870406edbc17cd6b582a4f1f684cc8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a4af6b044b92ea15528e54df3c2123715410648c42df683854d1eaaf9cc97b37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "210a12f1a06b39243f9e3f585ecd0b4e7e7a0f2511ce44b4f3072a77beed0458"
    sha256 cellar: :any,                 arm64_linux:       "6107c43803897dc775127a760591b090053094b66d9c94900ce6f837989ed826"
    sha256 cellar: :any,                 x86_64_linux:      "1caeaf9bbb8c499292d43de009fcdd058bdaadd30c76bae17da738db307b69eb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  # The test downloads a policy from the container registry.
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/kwctl")

    generate_completions_from_executable(bin/"kwctl", "completions", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kwctl --version")

    test_policy = "ghcr.io/kubewarden/policies/safe-labels:v0.1.7"
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
