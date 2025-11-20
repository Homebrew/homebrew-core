class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kwctl/archive/refs/tags/v1.30.1.tar.gz"
  sha256 "feec116250c97cac9eb0bd962b220c58f8ff8cea13a7c6c59d7d03d60922cd51"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ba8a28b49930bcfb1e9fe9877564301f6fb833c74bf4eb3278210b81100bd34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a071c1dc2fc9b5696c05e71b35b3200b4ecea627ab88c63e98b6db2e785c49e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e121569770daf3b6da0d9cfe69444c378ce56a06ce8f9bd48aa2d923304bcce0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0437cc12a2d51f93cdc19ebd9c970ac2d706c36361eb533a0caf945003661e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "751ec50baf5bda97a71755490834b3da973e4be18ca73b0cc8210c81562ac1e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90f3d7cd12ca5bb7d56e0c1562b0fc1eef89c5436239914ed6469669e4d3cef4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

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
