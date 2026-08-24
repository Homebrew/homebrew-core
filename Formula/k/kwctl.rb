class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/adm-controller/archive/refs/tags/v1.37.2.tar.gz"
  sha256 "08a374c320d7014a399111a88a7949886ee381b4df2bd94485ae9d7f2a2646ba"
  license "Apache-2.0"
  head "https://github.com/kubewarden/adm-controller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa3b3b9a679328629fb1bd22a877e8e858980da307b7fb7e0f1fc28154f8f6b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb4ddd2fe66a8f75206f6c3e24bda5ca7865951acea3adc597eaa89e9808924f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2f628d0d6f3479fad45c9fe276990c4e591e68e32c5b1b8f9cbea32757f5442"
    sha256 cellar: :any_skip_relocation, sonoma:        "79a877d74bde9758d1f9e2df44b117ce87bf9547b3cceeccde225f212cf730b5"
    sha256 cellar: :any,                 arm64_linux:   "de877e4f82577420fe015396ab96c88f207a93a94645b26b8977dc9ebc12192e"
    sha256 cellar: :any,                 x86_64_linux:  "cded51da47522bc1ca44018949500507932e6bdbe6e64d1cd72cc6c449161742"
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
