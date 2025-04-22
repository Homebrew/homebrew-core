class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kwctl/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "b995ae97914546f7a7ca179e0f838ab5bd7640bb261ae8ae842d181596ba1889"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11b659a467b66e49282aad02afcb8a9a199bff5a5ad43a4da90f06437158a09a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac00a2ea56b231b35fdd2bce2dc9fa13c3e267376ebb978a6052c68f50b4f13b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "447899b3dcb16bde7186573bb0172e17f8d0e905f747196d88acb923b6e1f082"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee9a772417da33afba87f6f63ae6c6dd528e260c1296c61827166a75905e33ef"
    sha256 cellar: :any_skip_relocation, ventura:       "a83b2ba4bbe7edf0d85f376d198a021fa919ea16c63d5772c1fe36df6b45dd0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7719bb9d7c524a9fce0fd79bf49dd6eb10d96de68955f4ba256abf6034d1340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9774e8db4e4bb91b5eff535aa99ac51ef6cbefdfe741db4d5c09562aad68f8c"
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
