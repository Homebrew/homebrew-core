class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/adm-controller/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "bc8e2808d98fce73b7ef53c249ef7433f354043bd6709463a60dd9587a0d27f1"
  license "Apache-2.0"
  head "https://github.com/kubewarden/adm-controller.git", branch: "main"

  bottle do
    manifest_sha256 "d5e345e9e0bca84ac98e106a2365816d70c296d52bc632cf4d01bd37bae0cfbc"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "01d128ff632c12a0b4f7fc1bbcd32eb9f0eadc2ddbf8257faae1f824499f952b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5ed8301587943e6f6d2548b47dbf97d9137ef645110a0b167a0c90f174a17272"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4112214975d6182a04bbc14828c345d9ca7655c5527a677d0748796bb309448d"
    sha256 cellar: :any,                 arm64_linux:       "70614e891c70cad9ac084927a70892e531e0aed64cee319fd7552734ed6dcafa"
    sha256 cellar: :any,                 x86_64_linux:      "a5db9f764d9f504b8750e5dd7ebac30a2c75105e1549857babc54976334a8300"
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
