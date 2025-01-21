class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kwctl/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "ae143c27b972b1584ba663a893857abfc21592904a777841410d2e426d7a8ef0"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e88b18a341684051a293a2f63ab03accdfd472814f19fe177c6d8051b728ea77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36e92e0bca45b9a81b42f95f45e7b1c9903b424b0cc22de0b9d1d97ab29da259"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "554a99755aa9c3959476c407e4294e8c9dcf402a9a1093aba1ad906b0b5b5481"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfed61cee8a4e191deef588d238eebbf2e375241b3a55e56a77c9a4fc12056c7"
    sha256 cellar: :any_skip_relocation, ventura:       "88bdd6d30f58fcb9337411264f5c00161b5cfa8d0b27fbc6261ce8de9d0e438a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fe9f2dfa1be2bb6c22e8ce8844da8b7a29b0b777d4325155184b4dd1f1f5fad"
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
