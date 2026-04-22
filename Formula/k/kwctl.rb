class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kubewarden-controller/archive/refs/tags/v1.34.2.tar.gz"
  sha256 "e06f3534102ed62f0c44c1d9e6438d8a8ef3d2b62051f397a749b12a41c39f99"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kubewarden-controller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06923013cee7fd6571f53fdfe181411b46faef1ddd3ac959ce42ec3e8bf47293"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93467fd111f8e63fce2cddff4bfb67164918874d156e82ffc2e3e55ea37e6566"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b941849e9d1ce931406c9253e17186e91957d92f7795f39746c7d076e05c4f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b42d272002e35b75b8ff7d1ee3984e0b4274033a8309dfc3e986375275af4b64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "422eefe06f83ece0237717468e0b26c68b5cd7b9b78f8bd94ae35b0cec4fdcc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eec04db71fb89a216e64754d3f5b4a851b82caf54349cec3607e22196c3295b4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

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
