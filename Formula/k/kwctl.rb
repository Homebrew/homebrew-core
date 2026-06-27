class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kubewarden-controller/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "c2d3ad9d6100b7ce81c6e565b7e99e01916168909ac558757864a406604e7825"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kubewarden-controller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03390b472fbed4fe9b35f12ad64fde5a02654e57958c77ffb58dd6633428ff01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eba5cf04d6372738228d0e396bd7130b0e0fc6d73fecbac743ec38759681acfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fdb243dd41f00f175ae261cf1991b030c346ab1377a41d1b56e1087b07667be"
    sha256 cellar: :any_skip_relocation, sonoma:        "c013e6da13c83c0e93c274ca9cb88e42fbc27213efb9138c827c17f16423bb10"
    sha256 cellar: :any,                 arm64_linux:   "969974059d37b4e1ab1a9f30c15fa8e839e3ed74e39efc402ad96e2695f2e98a"
    sha256 cellar: :any,                 x86_64_linux:  "0fec45c6f11e3db17808e0a98f95e1b26860765c18ac3c64a9446c23e1231080"
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
