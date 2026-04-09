class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kubewarden-controller/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "0bff470183f9ce478525aa1808723efa00c18293f5697334e0f9c27ffdae3d48"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kubewarden-controller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d01d5c139e3fb0b3f28fce245dc3994ebf8160801a2a1dc35f2a03292267c77a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b1a98be622100959156002676d71423a087b60df2e7f53b247cc442074b1f32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9eb997d4f368451d315709ff6f520140b26423d2d099f5647937f3bdd84429fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b6fce6e7b26fb7fdc1d9fae0053d4822fc2c9cb68bef384977fe027b49d6d9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "505d0ad023afeb4d342f71b11d83ec6e6dc2f52c7f7c56086da7454e76f122e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dade1df4a53d487775ab0ea278aea8bd5787d174dcdd62082d3635d98628a5c6"
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
