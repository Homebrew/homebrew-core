class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kubewarden-controller/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "86c05b6c66a508aebba1f71a5cc9e8e2141c33fe6c02153dc09f18335c3ea6a5"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kubewarden-controller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03ab5da22ca8cd7a1cbc74744871f621b7ecb68217b806287499524ce4eef063"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53fc524838bea3bcf20f5f6193289186e4947bd95e9e77c1e9a28ba2c16033d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0de13caa0b12b56d3db199676117f9f4cba415e00a14cb7aac1efd41d48b7834"
    sha256 cellar: :any_skip_relocation, sonoma:        "e904e73a587c5866e3ed18543d8850e50132c4685d985a7b2e4dcf5ef3ad6f0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35231069d346a482891ae7cca870f279c33bc319a80d1e83e7a13c4aca77cb97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfbbfb2c57214789996bc2ef22035450d18aac868f81716727743a010eb57b45"
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
