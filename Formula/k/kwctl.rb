class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kwctl/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "4bf0d5517b2f45555a395bf61caed151947a776b5c07fc3ba689cadb0e9d7677"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c134198339b931c79123b93b007901b228bfd55f7beca1289c904c16261a4109"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a79892d41c71df4ff6449f701150be9588d5b4d817d297f980235340621c111d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4af8518f621a243122ab710603b668da9d9fa7a785c64228cabbf07ff47b3c1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ab9b125368c78ef0e5b650bfc21cef6c4771195b53706cac4c51489eb3d6ee1"
    sha256 cellar: :any_skip_relocation, ventura:        "bc09ae158da6893d10a70357ba0c9d146dfe5cc3c4555d26fc9abf39f49c89df"
    sha256 cellar: :any_skip_relocation, monterey:       "07aace836444f3783d8df9d4a7d5686bb8a1f6ee4f15de1a775942d67e8f8f66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a20951a257bc5256c03717eda7b2a45f67bbe25ceaff1305143a142cc6a3fcc1"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_policy = "ghcr.io/kubewarden/policies/safe-labels:v0.1.7"
    assert_equal "kwctl #{version}", shell_output("#{bin}/kwctl --version").strip.split("\n")[0]
    system "#{bin}/kwctl", "pull", test_policy
    assert_match test_policy, shell_output("#{bin}/kwctl policies")

    (testpath/"ingress.json").write <<~EOS
      {
        "uid": "1299d386-525b-4032-98ae-1949f69f9cfc",
        "kind": {
          "group": "networking.k8s.io",
          "kind": "Ingress",
          "version": "v1"
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
    EOS
    (testpath/"policy-settings.json").write <<~EOS
      {
        "denied_labels": [
          "owner"
        ]
      }
    EOS

    output = shell_output(
      "#{bin}/kwctl run " \
      "registry://#{test_policy} " \
      "--request-path #{testpath}/ingress.json " \
      "--settings-path #{testpath}/policy-settings.json",
    )
    assert_match "The following labels are denied: owner", output
  end
end
