class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kubewarden-controller/archive/refs/tags/v1.32.1.tar.gz"
  sha256 "7683b958d19557462af93eb27a1ddb53bfd7579e3ab5b51e59e0db4ec6f28b76"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kubewarden-controller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f7d1d4cae388baf1545e914df1b3a610cc9f3d2ff785490c0c77cf4612a9e01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6313786e88edbb49aa0ec40a3a00483b37b0f8fcbf5036ee99409806e222d279"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91024d36bf9388318f162dd41c97df5f9deb99d89f10a41cdeb5e45525e92e50"
    sha256 cellar: :any_skip_relocation, sonoma:        "2688b7abc1d897d7f185e8d07c5191251d945636c559663b66c6fb141bb7f368"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8f200d70c1cc57e34797e90e7f4bfa33adcb92b3c0c020aeec9677dc9f7cbe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70c0e545e605128f4102b60c70808f26fd4354bb28c49afabe43c6ac532f1728"
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
