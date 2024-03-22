class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kwctl/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "2f5f96a4fea96d42826ad29a4246c595024d25b7745996b0125e9ac7587f70c9"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "094305630e54c745753dae1ef21989016eedd47d70a04e130c714c7a174b36a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d36c2b68ff0a2c5639b6176c9ab9923a4e751a96e863480edb8ce9dcd50c1c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9d31638815acd34f7a117aa6c732df6104c11cb2f1a2e7b9fe3c9a9236aea34"
    sha256 cellar: :any_skip_relocation, sonoma:         "f57729a4face7714175e1785ace00227e784b69e1d73dbc21e089e61dfc831f6"
    sha256 cellar: :any_skip_relocation, ventura:        "7c1c98c25d201fbd78fea1b9f745184f794533d383592bdba33b654f0a5f9825"
    sha256 cellar: :any_skip_relocation, monterey:       "a2d00ae0e27caabd2e5c574dd93ce8435dd38a7ef1240e5ca101bbee8fe751bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79f6b84000429e8f8b8f96f0d1b71bc2a7c1973322448f1a73a231ef20172b47"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
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

    (testpath/"ingress.json").write <<~EOS
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
