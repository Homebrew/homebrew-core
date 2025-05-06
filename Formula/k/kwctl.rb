class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kwctl/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "d6998fbb771fd016459fcf5428d47cdc18168ce6f9a10868387373598b2ce94b"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c5ad46b43cf7fb8eca774b99070894af4d64dc0d308befc15cee9917e9b888d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d1d26a26d8af3ec7ebb9d4035abe0ded4c415333e0cf6b2623c455510fc8efd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ddf658b0663efbdaeb3009413bc6efb694e13f1f0c178377089f77fbabfdd25b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d56ed65942c60c4ead35702f9465bc38b2ad7823c1f9bd93c535b49408d490a7"
    sha256 cellar: :any_skip_relocation, ventura:       "7b90070c65b0e2788f933b32fb1326d19a5bfc32f66c6f4482bc39ac0c261874"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bad30af781f7528aba014d09380fa5ae88e2e07a152acf680c3f278d2f7b707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "188444a041faae73724cd8aedd712ae574ac83ba76e199c0635f67a57e28acdf"
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
